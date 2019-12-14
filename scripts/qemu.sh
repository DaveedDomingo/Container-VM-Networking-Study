#!/bin/bash

# This handles everything that has to so with qemu


# - create
# - run
# - delete
# - copyfile
# - pullfile
# - mountfs
# - unmountfs

# Checks for the following environment variables
# QEMU_IMG
# QEMU_MOUNT
# QEMU_MEM

qemu_debug () {
	echo "[QEMU.sh] $1"
}

qemu_error () {
	echo "[QEMU.sh] (ERROR) $1 Exiting..."
}

qemu_print_usage () {
	qemu_debug " Usage:"
	qemu_debug "   create (created new qemu image)"
	qemu_debug "   destroy (deletes current qemu image)"
	qemu_debug "   mount (mount qemu image filesystem)"
	qemu_debug "   unmount (unmount qemu image filesystem)"
	qemu_debug "   run (starts the qemu VM)"
	qemu_debug "   kill (killed the currently running qemu)"
	qemu_debug "   password (change root password)"
	qemu_debug "   help (print usage)"
}

qemu_check_env () {

	if [ -z "$QEMU_IMG" ]; then
		qemu_error "QEMU_IMG environment variable is not defined."
		exit 1
	fi

	if [ -z "$QEMU_MOUNT" ]; then 
		qemu_error "QEMU_MOUNT environment variable is not defined."
		exit 1
	fi

	if [ -z "$QEMU_CORES" ]; then
		qemu_error "QEMU_CORES environment variable is not define"
		exit 1
	fi

	if [ -z "$QEMU_MEM" ]; then
		qemu error "QEMU_MEM environment variable is not defined."
		exit 1
	fi

	if [ -z "$OS_RELEASE_NAME" ]; then
		qemu_error "OS_RELEASE_NAME environment variable is not defined."
		exit 1
	fi

}

qemu_check_prereqs () {

  # update first 
  qemu_debug "Running apt-get update..."
  sudo apt-get update &> /dev/null

  # check for qemu
  which qemu-img &> /dev/null
  if [ $? -ne 0 ]; then
	  qemu_debug "Did not find qemu. Will try to install."
	  qemu_debug "Trying to install qemu"
	  sudo apt-get install qemu -qq &> /dev/null
	  if [ $? -eq 0 ]; then 
		  qemu_debug "Sucessfully installed qemu"
	  else
		  qemu_error "Failed to install qemu"
		  exit 1
	  fi
  fi

  # debootstrap
  which debootstrap &> /dev/null
  if [ $? -ne 0 ]; then
	  qemu_debug "Did not find debootstrap. Will try to install."
	  qemu_debug "Trying to install debootstrap"
	  sudo apt-get install debootstrap -qq &> /dev/null
	  if [ $? -eq 0 ]; then
		  qemu_debug "Sucessfully installed debootstrap"
	  else
		  qemu_error "Failed to install debootstrap"
		  exit 1
	  fi
  fi

}

qemu_mount () {
	
	# try and create mount
	mkdir $QEMU_MOUNT
	if [ $? -eq 0 ]; then 
		qemu_debug "Sucessfully created mount folder"
	else
		qemu_error "Failed to create mount folder."
		exit 1
	fi

	# mount fo directory
	sudo mount -o loop $QEMU_IMG $QEMU_MOUNT

	if [ $? -eq 0 ]; then
		qemu_debug "Sucessfully mounted $QEMU_IMG to $QEMU_MOUNT"
	else
		qemu_error "Failed to mount $QEMU_IMG to $QEMU_MOUNT"
		exit 1
	fi

}



qemu_unmount () {

	# unount mount directory
	sudo umount $QEMU_MOUNT
	if [ $? -eq 0 ]; then
		qemu_debug "Sucessfully unmounted $QEMU_MOUNT"
	else
		qemu_error "Failed to unmount $QEMU_MOUNT"
		exit 1
	fi

	# delete mount directory
	rm -rf $QEMU_MOUNT
	if [ $? -eq 0 ]; then 
		qemu_debug "Sucessfully deleted $QEMU_MOUNT"
	else
		qemu_error "Failed to delete $QEMU_MOUNT"
		exit 1
	fi
}




qemu_create () {

  # Create an image
  qemu_debug "Going to create image"
  qemu-img create $QEMU_IMG 4g
  if [ $? -eq 0 ]; then
	  qemu_debug "Sucessfully created image"
  else
	  qemu_error "Failed to create image"
	  exit 1
  fi

  #Now format your disk with some file system (EXT4)
  qemu_debug "Going to format image"
  mkfs.ext4 $QEMU_IMG
  if [ $? -eq 0 ]; then
	  qemu_debug "Sucessfully formatted $QEMU_IMG to EXT4"
  else
	  qemu_error "Failed to format $QEMU_IMG"
	  exit 1
  fi

  #mount 
  qemu_mount

  #Set family name
  qemu_debug "Installing base system"
  sudo debootstrap --arch amd64 $OS_RELEASE_NAME $QEMU_MOUNT
  if [ $? -eq 0 ]; then 
	  qemu_debug "Sucessfully installed base system"
  else
	  qemu_error "Failed to install base system"
	  exit 1
  fi

  # Set password
  qemu_debug "Setting up password for QEMU"
  sudo chroot $QEMU_MOUNT passwd
  qemu_debug "Installing other things"
  #install other things 
  sudo chroot $QEMU_MOUNT sudo apt-get install -y build-essential cmake libssl-dev docker.io

  #Unmount
  qemu_unmount

}

qemu_destroy () {

  # Check if image may be mounte
  qemu_debug "Checking is image is mounted or $QEMU_MOUNT exists"
  ls $QEMU_MOUNT &> /dev/null
  if [ $? -eq 0 ]; then
	 qemu_error "$QEMU_MOUNT exists. Is the image mounted?"
	exit 1
  fi

  # delete the image
  qemu_debug "Deleteing $QEMU_IMG"
  sudo rm $QEMU_IMG
  if [ $? -eq 0 ]; then
	  qemu_debug "Sucessfully deleted $QEMU_IMG"
  else
	  qemu_error "Failed to delete $QEMU_IMG"
	  exit 1
  fi

}


qemu_run () {

	#Chceck for image 
	stat $QEMU_IMG &> /dev/null
	if [ $? -ne 0 ]; then
		qemu_error "QEMU image $QEMU_IMG not found. Can't run Qemu."
		exit 1
	fi

	#Check for kernel to use 
	stat $KERNEL &> /dev/null
	if [ $? -ne 0 ]; then
	       qemu_error "Kernel $KERNEL. Cant run Qemu."
		exit 1
	fi		

	qemu_debug "Starting QEMU"

	sudo qemu-system-x86_64 -kernel $KERNEL -hda $QEMU_IMG -append "root=/dev/sda rw" --curses -m $QEMU_MEM -smp $QEMU_CORES
}

qemu_kill () {
  qemu_debug "Killing Qemu Script"
  sudo pkill -f "qemu.sh run"

  qemu_debug "Killing qemu-system-x86"
  sudo pkill -f qemu-system-x86
  
  qemu_debug "Killing qemu-system-x86"
  sudo pkill -f qemu-system-x86_64
}


qemu_password () {
  qemu_mount 

  # Set password
  qemu_debug "Setting up password for QEMU"
  sudo chroot $QEMU_MOUNT passwd

  qemu_unmount
}



qemu_check_env

qemu_check_prereqs

if [ $# -eq 1 ]; then
	if [ $1 == "create" ]; then
		qemu_create
	elif [ $1 == "destroy" ]; then
		qemu_destroy
	elif [ $1 == "mount" ]; then 
		qemu_mount
	elif [ $1 == "unmount" ]; then
		qemu_unmount
	elif [ $1 == "run" ]; then
		qemu_run
	elif [ $1 == "kill" ]; then
		qemu_kill
	elif [ $1 == "password" ]; then
		qemu_password
	elif [ $1 == "help" ]; then
		qemu_print_usage
	else 
		qemu_error "option not recognized"
		qemu_print_usage
	fi	

else
	qemu_debug "Incorrect # of arguments"
	qemu_print_usage
fi












#!/bin/bash

debug () {
  echo "[sockperf.sh] $1"
}

error () {
  echo "[sockperf.sh] (ERROR) $1"
}

usage () {
  echo "sockperf.sh usage:"
  echo " clone - clone sockperf repo"
  echo " remove - remove sockperf repo"
  echo " compile - compile sockperf"
  echo " clean - run make clean in sockperf repo"
  echo " client - run client program"
  echo " server - run server program"
}

check () {
	debug "Checking for nessesary environment variables"
	debug "Checking for required packages"
	set -x
	set +x
}

clone () {
	debug "Cloning sockperf repo (v2)"
	set -x
  git clone https://github.com/Mellanox/sockperf.git $SOCKPERF_SRC
  set +x
}

remove () {
	debug "Removing sockperf directory"
	set -x
	rm -rf $SOCKPERF_SRC
	set +x
}

compile () {
	debug "Compiling sockperf"
	set -x
	pushd $SOCKPERF_SRC
	./autogen.sh
	./configure
  make
	popd
	set +x
}

clean () {
	debug "Running make clean for sockperf"
	set -x
	pushd $SOCKPERF_SRC
	make clean
	popd
	set +x
}

client () {
	debug "Going to run $SOCKPERF_CLIENT_EXE $1"
  set -x
	$SOCKPERF_EXE $1
  set +x
}

server () {
	debug "Server things"
  set -x
  $SOCKPERF_EXE server
  set +x
}

main () {
	if [ $1 == "clone" ]; then
		clone
	elif [ $1 == "remove" ]; then
		remove
	elif [ $1 == "compile" ]; then
		compile
	elif [ $1 == "clean" ]; then
		clean
	elif [ $1 == "client" ]; then
		client
	elif [ $1 == "server" ]; then
		server
	elif [ $1 == "help" ]; then
		usage
	else
		error "option not recognized"
		usage
	fi
}

main $1

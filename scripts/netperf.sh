#!/bin/bash

debug () {
  echo "[netperf.sh] $1"
}

error () {
  echo "[netperf.sh] (ERROR) $1"
}

usage () {
  echo "netperf.sh usage:"
  echo " clone - clone netperf repo"
  echo " remove - remove netperf repo"
  echo " compile - compile netperf"
  echo " clean - run make clean in netperf repo"
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
	debug "Cloning netperf repo (verison 2.7.0)"
	set -x
	git clone -b netperf-2.7.0 https://github.com/HewlettPackard/netperf.git $NETPERF_SRC 
	set +x
}

remove () {
	debug "Removing netperf directory"
	set -x
	rm -rf $NETPERF_SRC
	set +x
}

compile () {
	debug "Compiling netperf"
	set -x
	pushd $NETPERF_SRC
	./configure
	make
	popd
	set +x
}

clean () {
	debug "Running make clean for netperf"
	set -x
	pushd $NETPERF_SRC
	make clean
	popd
	set +x
}

client () {
	debug "Going to run $NETPERF_CLIENT_EXE $1"
	$NETPERF_CLIENT_EXE $1
}

server () {
	debug "Server things"
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

#!/bin/bash

set -x

# Cloudlab Variables
export CLIENT_HOSTNAME=djd240@apt086.apt.emulab.net
export SERVER_HOSTNAME=djd240@apt079.apt.emulab.net
export CLIENT_LOCAL_IP=10.0.1.1 # do not modify
export SERVER_LOCAL_IP=10.0.1.2 # do not modify

# Set necessary environment variables
export BASE=$PWD
export SCRIPTS_PATH=$BASE/scripts
export TOOLS_PATH=$BASE/tools
export RESULTS_PATH=$BASE/results

# ==== DOCKER ========== #
export DOCKER_PATH=$BASE/docker

# ============ NETPERF ================#

# Environment Variables
export NETPERF_SRC=$TOOLS_PATH/netperf
export NETPERF_CLIENT_EXE=$NETPERF_SRC/src/netperf
export NETPERF_SERVER_EXE=$NETPERF_SRC/src/netserver
export NETPERF_PORT=12865

# Aliases
alias netperf-clone='$SCRIPTS_PATH/netperf.sh clone'
alias netperf-remove='$SCRIPTS_PATH/netperf.sh remove'
alias netperf-compile='$SCRIPTS_PATH/netperf.sh compile'
alias netperf-client='$SCRIPTS_PATH/netperf.sh client'
alias netperf-server='$SCRIPTS_PATH/netperf.sh server'
alias netperf-help='$SCRIPTS_PATH/netperf.sh help'


# =========== SOCKPERF ============== #

# Environment Variables
export SOCKPERF_SRC=$TOOLS_PATH/sockperf
export SOCKPERF_EXE=$SOCKPERF_SRC/sockperf
export SOCKPERF_PORT=11111

# Aliases
alias sockperf-clone='$SCRIPTS_PATH/sockperf.sh clone'
alias sockperf-remove='$SCRIPTS_PATH/sockperf.sh remove'
alias sockperf-compile='$SCRIPTS_PATH/sockperf.sh compile'
alias sockperf-client='$SCRIPTS_PATH/sockperf.sh client'
alias sockperf-server='$SCRIPTS_PATH/sockperf.sh server'
alias sockperf-help='$SCRIPTS_PATH/sockperf.sh help'


# =========== KERNEL ======================= #

# Variables
export KERNEL=/boot/vmlinuz-4.20
export OS_RELEASE_NAME=$(sed -n 's/^\UBUNTU_CODENAME=//p' < /etc/os-release)


# =========== QEMU ================# 

# Environment Variables
export QEMU_IMG=$BASE/qemu/qemu-image.img
export QEMU_MOUNT=$BASE/qemu/mountdir
export QEMU_MEM='4096M'
export QEMU_CORES=4

# Aliases
alias qemu-create='$SCRIPTS_PATH/qemu.sh create'
alias qemu-destroy='$SCRIPTS_PATH/qemu.sh destroy'
alias qemu-mount='$SCRIPTS_PATH/qemu.sh mount'
alias qemu-unmount='$SCRIPTS_PATH/qemu.sh unmount'
alias qemu-run='$SCRIPTS_PATH/qemu.sh run'
alias qemu-kill='$SCRIPTS_PATH/qemu.sh kill'
alias qemu-password='$SCRIPTS_PATH/qemu.sh password'
alias qemu-help='$SCRIPTS_PATH/qemu.sh help'


set +x



# Then set all aliases


# === NETPERF === #
# clone netperf 2.7.0
#git clone -b netperf-2.7.0 https://github.com/HewlettPackard/netperf.git

#compile netperf
#cd netperf
#./configure
#make

# starting neperf server
#netserver

# ============== #

# ==== SOCKPERF ==== #
# cloning v2
#git clone https://github.com/Mellanox/sockperf.git
#cd sockperf
#./autogen.sh
#./configure
#make

# =================== #


# ==== SPARKYFISH ==== #
# download binary




# ======== DOCKER ====== #
#update repo
#sudo apt-get update
#sudo apt-get install docker.io
# =========================== #

# ====== KVM Hypervisor ====== #

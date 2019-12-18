# container-study
Forked from daveeddomingo/container-study

## Introduction
This repo supports the following tools
- netperf
- socketperf
- sparkyfish

## Architecture
- Two test nodes
- Master node

## Initializing Cloudlab Instance
In order to have you need to have slave nodes connected by mellanox

Use any of the cloudlab profiles in the cloudlab-profiles directory.
There are the following cloudlab profiles
- r profile = two cloudlab utah nodes, hardware type

## Setting up testing environment
1. Ensure the inodes are properluy configures in setvars and run setvars then
run setvars
```
source ./setvars.sh
```

## Running Experiments


## Generating Graphs

remote

### Aliases
- netperf-clone : clones netperf repo
- netperf-compile : compiles netperf
- netperf-clean : cleans netperf repo
- netperf-run : runs netperf client
- netperf-server-start : starts netperf server
- netperf-server-stop : stops netperf server

- sockperf-clone : clones sockperf repo
- sockperf-compile : compiles sockperf
- sockperf-clean : cleans sockperf repo
- sockperf-remove : removes sockperf repo

- qemu-create : created qemu image and installed debian
- qemu-destroy : destroyes qemu image
- qemu-mount : mounts qemu image to folder
- qemu-unmount: unmount qemu image folder
- qemu-run: runs qemu vm
- qemu-kill: kills any running qemu instance
- qemu-passwork: allows to set the root password of qemu vm
- qemu-help: lists qemu commands


#### Setting up Cloudlab Instance
1. In order to setup cloudlab instance, create a cloud lab profile and copy the source xml configuration from `cloudlab-profiles/cloudlab-profile.xml`
2. Start a new cloud lab experiment utilizing the new profile you created.
3. In the end there should be two Cloudlab topology connected to the internet with 1Gbps ethernet and connected to each other by 10Gpbs Infiniband. 

#### Host configuration
In order to run Sockperf on the host configuration do the following on each node:
1. Clone the repo and navigate into it
```
git clone https://github.com/DaveedDomingo/Container-VM-Networking-Study.git
```
```
cd Container-VM-Networking-Study
```
2.  Now source the setvars script to set the necessary aliases to intermediate scripts
```
source ./setvars.sh 
``` 
3. Clone the Sockperf repo. This will place the repo in the tools folder
```
sockperf-clone
```
4. Compile the sockperf source 
```
sockperf-compile
```
#### Running Sockperf TCP Benchmark
On the second node,  navigate to the sockperf repo and launch the Sockperf server. This will host the server on the default port `11111`
```
node-1$ ./sockperf server --tcp 
```

Now on the first node, navigate to the sockperf repo and run the Sockperf benchmark replacing `$NODE_1` with the domain name of the second node and `$MESS_SIZE` with the message size you want to run the benchmark with (in bytes)
```
node-0$ ./sockperf throughput --tcp -i $NODE_1 -p 11111 -t 30 --msg-size=$MESS_SIZE
```

#### Running Sockperf UDP Benchmark
On the second node,  navigate to the sockperf repo and launch the Sockperf server. This will host the server on the default port `11111` and set the connection to UDP by default
```
node-1$ ./sockperf server 
```

Now on the first node, navigate to the sockperf repo and run the Sockperf benchmark replacing `$NODE_1` with the domain name of the second node and `$MESS_SIZE` with the message size you want to run the benchmark with (in bytes)
```
node-0$ ./sockperf throughput -i $NODE_1 -p 11111 -t 30 --msg-size=$MESS_SIZE
```

#### Docker Container Configuration

### Installing Docker
Install docker via apt get 
```
sudo apt-get update
```
```
sudo apt-get install docker.io 
```

#### Generating Sockperf Docker Images
On each node ensure the sockperf repo is cloned and the source is compiled.
1. Navigate to the docker folder
```
cd docker
```
2. Generate the Sockperf docker image using the `gen_sockperf.sh` script. This will package the sockperf executable within a docker image to be used. The docker image is automatically added to the list of available docker images in docker
```
./gen_sockperf.sh
```

#### Setting up Overlay network
1. On the primary node initiate a docker swarm where `$PUBLIC_IP` is the public ip address of the node
```
docker swarm init --advertise-addr $PUBLIC_IP
```
2. Copy the output of the command and run it on the secondary node to add it to the docker swarm
3. On the primary node create an attachable overlay network
```
docker network create -d overlay --attachable overnet
```

#### Launching Sockperf TCP Server Service
On the primary node, create a sockper-server service and pin it to the remote node. 
```
docker service create --constraint node.role==worker --network overnet --name sockperf-server sockperf server --tcp
```
#### Running Sockperf TCP Throughput Benchmark
On the secondary node inspect the overlay network IP that was it was assigned
```
docker network inspect overnet
```
On the primary node run a sockperf container running the benchmark replacing `$MESS_SIZE` with the message size you want to run with benchmark with (in bytes) and replacing `$REMOTE_IP` with overlay IP address retrieved from the previous step.
```
docker run --rm --network overnet --name sockperf-client sockperf throughput --tcp -i $REMOTE_IP -p 11111 -t 30 --msg-size=$MESS_SIZE
```

#### Stopping Sockperf TCP Server Service
On the primary node, stop the Sockperf TCP Service using the `service rm` command
```
docker service rm sockperf-server
```

#### Launching Sockperf UDP Server Service
On the primary node, create a sockper-server service and pin it to the remote node. 
```
docker service create --constraint node.role==worker --network overnet --name sockperf-server sockperf server
```

#### Running Sockperf UDP Throughput Benchmark
On the secondary node inspect the overlay network IP that was it was assigned
```
docker network inspect overnet
```
On the primary node run a sockperf container running the benchmark replacing `$MESS_SIZE` with the message size you want to run with benchmark with (in bytes) and replacing `$REMOTE_IP` with overlay IP address retrieved from the previous step.
```
docker run --rm --network overnet --name sockperf-client sockperf throughput -i $REMOTE_IP -p 11111 -t 30 --msg-size=$MESS_SIZE
```

#### Stopping Sockperf UDP Server Service
On the primary node, stop the Sockperf TCP Service using the `service rm` command
```
docker service rm sockperf-server
```


#### VM Configuration

#### Creating Virtual Machines
Connect to each node using X11 forwarding. 
1. On each node, ensure the nessecary KVM packages are installed
```
 sudo apt-get install qemu-kvm libvirt-bin bridge-utils virt-manager
```
2. Download a copy of the Ubuntu 18.04 iso 
```
wget http://releases.ubuntu.com/18.04/ubuntu-18.04.3-desktop-amd64.iso
```
3. Launch virt-manager
```
sudo virt-manager
```
4. Install a new virtual machine using the downloaded Ubuntu iso as the installation disk
5. Configure the virtual machines with the default parameters. 
6. Let the virtual machine run and complete the installation

#### VM+Container Configuration

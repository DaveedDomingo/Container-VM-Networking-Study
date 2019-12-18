# container-study

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

#### VM Configuration

#### VM+Container Configuration

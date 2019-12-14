#!/bin/bash

SOCKPERF_DOCKERFILE_PATH=$DOCKER_PATH/dockerfiles/sockperf.dockerfile

# Copy what we care about 
sudo docker build -f $SOCKPERF_DOCKERFILE_PATH -t sockperf $SOCKPERF_SRC
sudo docker images


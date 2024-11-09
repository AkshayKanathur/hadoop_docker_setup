#!/usr/bin/bash

# Reconfigure any unpacked but unconfigured packages
# sudo dpkg --configure -a && \

# Updating system and installing Docker
# sudo apt-get update && \
# sudo apt-get install -y docker.io && \
sudo snap install -y docker && \

# Pulling the Hadoop Docker Image
sudo docker pull sequenceiq/hadoop-docker:2.7.1 && \

# Running the Container
sudo docker run -it -p 50070:50070 -p 8088:8088 sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash
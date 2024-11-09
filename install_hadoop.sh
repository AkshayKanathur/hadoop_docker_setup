#!/usr/bin/bash

# Reconfigure any unpacked but unconfigured packages
if ! sudo dpkg --configure -a; then
    echo "dpkg encountered an error."
fi

# Updating system and installing Docker
if ! sudo apt-get update || ! sudo apt-get install -y docker.io; then
    echo "apt failed to install Docker, attempting snap installation."
    sudo snap install docker
fi

# Copying the start-hadoop script to /usr/local/bin
sudo cp start-hadoop /usr/local/bin

# Pulling the Hadoop Docker Image
sudo docker pull sequenceiq/hadoop-docker:2.7.1

# Running the Container
sudo docker run -it -p 50070:50070 -p 8088:8088 sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash
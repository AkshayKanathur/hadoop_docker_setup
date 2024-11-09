#!/usr/bin/bash

# Reconfigure any unpacked but unconfigured packages
if ! sudo dpkg --configure -a; then
    echo "dpkg encountered an error. Exiting."
    exit 1
fi

# Update the system
if ! sudo apt-get update; then
    echo "Failed to update system with apt. Exiting."
    exit 1
fi

# Install Docker with apt, fallback to snap if apt fails
if ! sudo apt-get install -y docker.io; then
    echo "apt failed to install Docker, attempting snap installation."
    if ! command -v snap &> /dev/null; then
        echo "Snap is not installed. Exiting."
        exit 1
    elif ! sudo snap install docker; then
        echo "Snap failed to install Docker. Exiting."
        exit 1
    fi
fi

# Copy the start-hadoop script to /usr/local/bin
if ! sudo cp start-hadoop /usr/local/bin; then
    echo "Failed to copy start-hadoop to /usr/local/bin. Exiting."
    exit 1
fi

# Pull the Hadoop Docker image
if ! sudo docker pull sequenceiq/hadoop-docker:2.7.1; then
    echo "Failed to pull Hadoop Docker image. Exiting."
    exit 1
fi

# Run the Docker container in detached mode
if ! sudo docker run -d -p 50070:50070 -p 8088:8088 sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash; then
    echo "Failed to run the Docker container. Exiting."
    exit 1
fi
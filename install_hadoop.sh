#!/usr/bin/bash

# Ask if the user is ready to install
read -p "Are you ready to install Docker and Hadoop? (y/n): " confirm_install
if [[ "$confirm_install" != "y" && "$confirm_install" != "Y" ]]; then
    echo "Installation aborted."
    exit 0
fi

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

# Ask if the user wants to start Hadoop
read -p "Do you want to start Hadoop now? (y/n): " confirm_start
if [[ "$confirm_start" != "y" && "$confirm_start" != "Y" ]]; then
    echo "Hadoop installation completed, but Hadoop was not started."
    exit 0
fi

# Run the Docker container using start-hadoop script
if ! start-hadoop; then
    echo "Failed to run the Docker container. Exiting."
    exit 1
fi
#!/usr/bin/bash

pull_image() {
    sudo docker pull sequenceiq/hadoop-docker:2.7.1 || {
        echo "Pulling Hadoop Docker image failed"
        exit 1
    }
}

run_hadoop_container() {
    sudo docker run -it -p 50070:50070 -p 8088:8088 sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash || {
        echo "Running Hadoop container failed"
        exit 1
    }
}

install_docker() {
    echo "Checking Docker installation..."
    sleep 2

    if command -v docker >/dev/null 2>&1; then
        echo "Docker is already installed."
        sleep 2
    else
        echo "Docker not found. Installing Docker..."
        sleep 3

        if command -v snap >/dev/null 2>&1; then
            sudo snap install docker
        elif command -v apt >/dev/null 2>&1; then
            sudo dpkg --configure -a
            sudo apt update -y && sudo apt install -y docker.io
        elif command -v apt-get >/dev/null 2>&1; then
            sudo dpkg --configure -a
            sudo apt-get update -y && sudo apt-get install -y docker.io
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y docker
        elif command -v pacman >/dev/null 2>&1; then
            sudo pacman -Sy --noconfirm docker
        elif command -v zypper >/dev/null 2>&1; then
            sudo zypper install -y docker
        else
            echo "No suitable package manager found to install Docker."
            exit 1
        fi
    fi
}

prompt_with_default() {
    read -p "$1 (y/n): " choice
    choice=${choice:-y}
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        return 0
    else
        return 1
    fi
}

if prompt_with_default "Are you ready for installation ?"; then
    echo "Starting the installation process..."
    sleep 2

    install_docker

    if prompt_with_default "Do you want to pull the Hadoop Docker image?"; then
        pull_image
    else
        echo "Hadoop image pull was canceled. Exiting."
        exit 0
    fi

    if prompt_with_default "Do you want to set up the start-hadoop script?"; then
        sudo cp start-hadoop /usr/local/bin
        echo "start-hadoop script set up successfully."
        sleep 3
        echo "Next time, you can simply type 'start-hadoop' to start Hadoop."
        sleep 3
    else
        echo "start-hadoop script setup skipped."
        sleep 2
    fi

    if prompt_with_default "Do you want to run Hadoop now?"; then
        run_hadoop_container
    else
        echo "Hadoop setup completed, but Hadoop was not started."
        sleep 3
    fi

    echo "Script completed."

else
    echo "Installation aborted."
fi

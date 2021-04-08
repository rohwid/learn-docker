#!/bin/bash

sudo apt update
 
sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \ 
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \ 
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io

apt-cache madison docker-ce

read -p "Please specify the Docker version from the above option: " DOCKER_VERSION

sudo apt install docker-ce=${DOCKER_VERSION} docker-ce-cli=${DOCKER_VERSION} containerd.io

echo "DONE."
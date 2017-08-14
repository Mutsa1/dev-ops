#!/bin/bash

echo "Uninstall old versions \n"

sudo apt-get remove docker docker-engine docker.io

echo "Uninstall old versions Completed \n"

echo "Install using the repository \n"

echo "\n"

echo " SET UP THE REPOSITORY \n"

echo "1. Update the apt package index: \n"

sudo apt-get update

echo "2. Install packages to allow apt to use a repository over HTTPS: \n"

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

echo "3. Add Docker’s official GPG key: \n"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "Verify that the key fingerprin \n "
sudo apt-key fingerprint 0EBFCD88

echo "set up the stable repository \n"

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

echo "============================= INSTALL DOCKER CE ============================ \n\n"

echo "Update the apt package index: \n"
sudo apt-get update

echo "Install the latest version of Docker CE \n"
sudo apt-get install docker-ce

echo "After the successful completion of the docker please check with \n\n\n"

echo "DOKER VERSION \n\n"

docker version

echo "TO TEST TYPE : sudo docker run hello-world"


 
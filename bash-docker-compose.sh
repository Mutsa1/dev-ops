#!/bin/bash

echo "Install Compose : 1.14.0"

curl -L https://github.com/docker/compose/releases/download/1.14.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo "Docker compose installed successfully"

echo "CURRENT VERSION"

docker-compose --version

#!/bin/bash

sudo add-apt-repository ppa:webupd8team/java

sudo apt-get update

sudo apt-get install oracle-java8-installer

echo "GET THE PATH OF JAVA-8"

sudo update-alternatives --config java

echo "=========================== SET JAVA_HOME =============================="

echo "Follow below steps"

echo "copy the java-8 path"

echo "RUN following"

echo "sudo nano /etc/environment"

echo "JAVA_HOME=<set path in with double quotes>"

echo "run the following command"

echo "source /etc/environment" 

echo $JAVA_HOME

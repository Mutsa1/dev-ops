#!/bin/bash

echo "Prerequisites"

echo "Ubuntu 16.04 server"

echo "================ INSTALL JAVA 8 =================="

echo "update the package index"

sudo apt-get update

echo "Install the Java Runtime Environment (JRE)"

sudo apt-get install default-jre

echo "Install Java Development Kit (JDK)"

sudo apt-get install default-jdk

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

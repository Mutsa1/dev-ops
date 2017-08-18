#!/bin/bash

sudo apt-get install oracle-java9-installer

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

# JENKINS

```bash
export CLUSTER_DNS=[...]
export CLUSTER_IP=[...]

```

## Connect to EC2 instance

```bash
ssh -i workshop.pem docker@$CLUSTER_IP
```

```bash
docker container run -d --name jenkins -p 8080:8080 jenkins:alpine

docker container ls

PRIVATE_IP=[...] # e.g. 172.31.21.216

curl -i "http://$PRIVATE_IP:8080"

docker container rm -f jenkins

docker container ls

docker service create --name jenkins -p 8080:8080 jenkins:alpine

docker service ps jenkins

exit

open "http://$CLUSTER_DNS:8080"

ssh -i workshop.pem docker@$CLUSTER_IP

docker service rm jenkins
```

## Create a yml file to run the docker stack

jenkins-service.yml

# RUN

## Here are two ways which we follow to run the mongo

### 1

Clone or create the docker-compose

If you go with docker compose file create docker-compose.yml and run the following

```bash
docker-compose up -d
```

HELP TEXT : -d - detached mode

### 2

JUST RUN THE FOLLOWING

```bash
docker container run -d --name mongo-sample mongo:3.2
```

HELP TEXT : –name option to assign a name to the container(--name mongo-sample)
            -d - detached mode
            mongo:3.2 - image name : version
            If we don't give the version it will fetch the default image from docker hub

## JUMP INTO THE RUNNING CONTAINER

```bash
docker container exec -ti mongo-sample bash
```

Check the status of the container

```bash
ps ax
```

Come out of the container

```bash
exit
```


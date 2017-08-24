# RUNNING TWO NODE CLUSTER of remote servers

## BASH Connecting to Container

```bash
docker exec -it cassandra-one bash
```

```bash
docker exec -it cassandra-two bash
```

## Connect Node 1 running in Host:18.220.240.109

NOTE : --net multinoderemotemachines_default[this will be changed according to your folder name]

```bash
docker run -it --net multinoderemotemachines_default  --link cassandra-one:cassandra --rm cassandra cqlsh cassandra
```

## Connect Node 1 running in Host:52.14.135.228

```bash
docker run -it --net multinoderemotemachines_default  --link cassandra-two:cassandra --rm cassandra cqlsh cassandra
```

## DO This All steps in one node and cross check from the other node

### Create Keyspace and a table

#### Check the keyspaces, To list out the keysapce

```bash
desc keyspaces;
```

#### To List out the Tables

```bash
desc tables;
```

#### Script to create the Keyspace demo

```bash
CREATE KEYSPACE IF NOT EXISTS demo
    WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }
    AND DURABLE_WRITES = true;
```

### Script to create a table user

```bash
use demo; # create a table within keyspace, execute this

CREATE TABLE IF NOT EXISTS user (
    id text,
    login text,
    password text,
    firstname text,
    lastname text,
    email text,
    activated boolean,
    lang_key text,
    activation_key text,
    reset_key text,
    reset_date timestamp,
    authorities set<text>,
    PRIMARY KEY(id)
);

INSERT INTO user (id, login, password , firstname, lastname ,email ,activated ,lang_key, activation_key, authorities)
VALUES('1','system','$2a$10$mE.qmcV0mFU5NcKh73TZx.z4ueI/.bDWbj0T1BYyqP481kGGarKLG','','System','system@localhost',true,'en','', {'ROLE_USER', 'ROLE_ADMIN'});

```

## To create new node within the same cluster

create a docker-compose just like the docker-compose-two.yml and add respective properties.


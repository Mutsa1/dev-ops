# CONECT TO CASSANDRA RUNNING

```bash
 docker run -it --link cassnadra_cassandra-one_1:cassandra --rm cassandra sh -c 'exec cqlsh "$CASSANDRA_PORT_9042_TCP_ADDR"'
```

```bash
 docker run -it --link cassnadra_cassandra-two_1:cassandra --rm cassandra sh -c 'exec cqlsh "$CASSANDRA_PORT_9042_TCP_ADDR"'
```
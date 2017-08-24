# Currntly we are using ELasticsearch with run command below

```bash
docker run -d \
  -v /var/db/elasticsearch-two/data:/usr/share/elasticsearch/data \
  -p 9200:9200 \
  -p 9300:9300 \
  elasticsearch:2.4.1 \
  --cluster.name=wsindex \
  --network.publish_host=192.168.55.11 \
  --discovery.zen.ping.multicast.enabled=false \
  --discovery.zen.ping.unicast.hosts=192.168.55.12 \
  --discovery.zen.ping.timeout=3s \
  --discovery.zen.minimum_master_nodes=1

docker run -d \
  -v /var/db/elasticsearch-two/data:/usr/share/elasticsearch/data \
  -p 9200:9200 \
  -p 9300:9300 \
  elasticsearch:2.4.1 \
  --cluster.name=wsindex \
  --network.publish_host=192.168.55.12 \
  --discovery.zen.ping.multicast.enabled=false \
  --discovery.zen.ping.unicast.hosts=192.168.55.11 \
  --discovery.zen.ping.timeout=3s \
  --discovery.zen.minimum_master_nodes=1

```
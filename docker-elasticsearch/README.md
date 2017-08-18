# ELasticsearch

```bash
docker run -d \
  -p 9200:9200 \
  -p 9300:9300 \
  ehazlett/elasticsearch \
  --cluster.name=unicast \
  --network.publish_host=54.169.122.211 \
  --discovery.zen.ping.multicast.enabled=false \
  --discovery.zen.ping.unicast.hosts=54.255.143.68 \
  --discovery.zen.ping.timeout=3s \
  --discovery.zen.minimum_master_nodes=1

docker run -d \
  -p 9200:9200 \
  -p 9300:9300 \
  ehazlett/elasticsearch \
  --cluster.name=unicast \
  --network.publish_host=54.255.143.68 \
  --discovery.zen.ping.multicast.enabled=false \
  --discovery.zen.ping.unicast.hosts=54.169.122.211 \
  --discovery.zen.ping.timeout=3s \
  --discovery.zen.minimum_master_nodes=1

```
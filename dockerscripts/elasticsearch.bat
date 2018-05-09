@echo off
docker run --name elasticsearch -d -p 9200:9200 -p 9300:9300 --rm^
 -e "discovery.type=single-node"^
 docker.elastic.co/elasticsearch/elasticsearch-oss:6.1.1
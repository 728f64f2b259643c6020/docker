#name of container: elasticsearch/swarm
#versison of container: 5.0.0
FROM elasticsearch:5.0.0
MAINTAINER Elasticsearch Cluster "FTEL"

COPY config/elasticsearch.yml /usr/share/elasticsearch/config

EXPOSE 9200 9300
ENTRYPOINT ["bootstrap.sh"]
CMD ["elasticsearch"]

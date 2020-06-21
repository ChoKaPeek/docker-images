ARG TAG=7.4.2
FROM chokapeek/elasticsearch:${TAG}

WORKDIR /opt/elasticsearch

# KUZZLEIO TWEAKS
ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"

RUN echo "xpack.graph.enabled: false" >> config/elasticsearch.yml
RUN echo "xpack.monitoring.enabled: false" >> config/elasticsearch.yml
RUN echo "xpack.security.enabled: false" >> config/elasticsearch.yml
RUN echo "xpack.watcher.enabled: false" >> config/elasticsearch.yml
RUN echo "cluster.name: kuzzle" >> config/elasticsearch.yml
RUN echo "node.name: alyx" >> config/elasticsearch.yml
RUN echo "discovery.type: single-node" >> config/elasticsearch.yml

COPY jvm.options /usr/share/elasticsearch/config/jvm.options
# Configure entry point
COPY docker-entrypoint.sh /opt/
RUN ["chmod", "+x", "/opt/docker-entrypoint.sh"]
ENTRYPOINT ["/opt/docker-entrypoint.sh"]

ARG TAG=7.4.2
FROM chokapeek/elasticsearch:${TAG}

WORKDIR /opt/elasticsearch

#####
# KUZZLEIO TWEAKS
ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"

RUN echo "xpack.graph.enabled: false" >> config/elasticsearch.yml \
 && echo "xpack.monitoring.enabled: false" >> config/elasticsearch.yml \
 && echo "xpack.security.enabled: false" >> config/elasticsearch.yml \
 && echo "xpack.watcher.enabled: false" >> config/elasticsearch.yml \
 && echo "cluster.name: kuzzle" >> config/elasticsearch.yml \
 && echo "node.name: alyx" >> config/elasticsearch.yml \
 && echo "discovery.type: single-node" >> config/elasticsearch.yml

COPY jvm.options /usr/share/elasticsearch/config/jvm.options
#####

# elasticsearch needs non-root user
RUN useradd elasticsearch \
 && chown -R elasticsearch /opt/elasticsearch

# Configure entry point
COPY docker-entrypoint.sh /opt/
RUN ["chmod", "+x", "/opt/docker-entrypoint.sh"]
ENTRYPOINT ["/opt/docker-entrypoint.sh"]

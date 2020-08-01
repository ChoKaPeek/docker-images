ARG TAG=7.4.2
FROM chokapeek/elasticsearch:${TAG}

ARG YML="/opt/elasticsearch/config/elasticsearch.yml"

#####
# KUZZLEIO TWEAKS
ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"

COPY jvm.options /usr/share/elasticsearch/config/jvm.options

RUN echo "xpack.graph.enabled: false" >> $YML \
 && echo "xpack.monitoring.enabled: false" >> $YML \
 && echo "xpack.security.enabled: false" >> $YML \
 && echo "xpack.watcher.enabled: false" >> $YML \
 && echo "cluster.name: kuzzle" >> $YML \
 && echo "node.name: alyx" >> $YML \
 && echo "discovery.type: single-node" >> $YML
#####

# elasticsearch needs non-root user
RUN useradd elasticsearch \
 && chown -R elasticsearch /opt/elasticsearch

# Configure entry point
COPY docker-entrypoint.sh /opt/
RUN ["chmod", "+x", "/opt/docker-entrypoint.sh"]
ENTRYPOINT ["/opt/docker-entrypoint.sh"]

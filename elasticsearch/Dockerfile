ARG TAG=7.4.2
FROM adoptopenjdk/openjdk11:slim

ARG TAG
ARG ES_VERSION=${TAG%%-*}
ARG ELASTIC="https://artifacts.elastic.co/downloads/elasticsearch"
ARG YML="/opt/elasticsearch/config/elasticsearch.yml"

# Setup nginx proxy
COPY default.nginx.conf /etc/nginx/sites-available/default

RUN apt update \
	&& apt install -y curl wget nginx

# Setup es
RUN mkdir -p /opt/elasticsearch \
 && cd /opt/elasticsearch \
 && curl -fsSL --compressed \
    ${ELASTIC}/elasticsearch-${ES_VERSION}-no-jdk-linux-x86_64.tar.gz \
    | tar xz --strip-components=1
# strip-components=1 removes root folder

# Provided JNA does not contain a linux-arm/libjnidispatch.so, updating
RUN rm /opt/elasticsearch/lib/jna*.jar \
 && wget -O /opt/elasticsearch/lib/jna.jar \
    https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.2.0/jna-5.2.0.jar

# Update config
RUN echo "http.port: 9292" >> $YML \
 && echo "network.host: 127.0.0.1" >> $YML \
 && echo "xpack.ml.enabled: false" >> $YML

# Remove warning about arm architecture
RUN echo "bootstrap.system_call_filter: false" >> $YML

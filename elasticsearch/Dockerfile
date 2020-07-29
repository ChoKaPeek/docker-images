ARG TAG=7.4.2
FROM adoptopenjdk/openjdk11:slim

ARG TAG
ARG ES_VERSION=${TAG}
ARG ELASTIC="https://artifacts.elastic.co/downloads/elasticsearch"

RUN apt update \
	&& apt install -y curl wget nginx

# Setup nginx proxy
COPY default.nginx.conf /etc/nginx/sites-available/default

# Setup es
RUN mkdir elasticsearch
WORKDIR /opt/elasticsearch

RUN curl -fsSL --compressed \
  ${ELASTIC}/elasticsearch-${ES_VERSION}-no-jdk-linux-x86_64.tar.gz \
  | tar xz --strip-components=1
# strip-components=1 removes root folder

# Add arm JNA to the resource path
RUN wget -P /opt/elasticsearch/lib -O jna.jar \
  https://github.com/java-native-access/jna/blob/master/lib/native/linux-arm.jar

# Update config
RUN echo "http.port: 9292" >> config/elasticsearch.yml
RUN echo "network.host: 127.0.0.1" >> config/elasticsearch.yml
RUN echo "xpack.ml.enabled: false" >> config/elasticsearch.yml

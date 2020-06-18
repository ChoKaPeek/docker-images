ARG TAG=buster
FROM balenalib/armv7hf-debian-node:latest-${TAG}

WORKDIR /var/app

RUN [ "cross-build-start" ]

RUN install_packages python build-essential

RUN set -x

RUN npm install boost-geospatial-index

RUN [ "cross-build-end" ]

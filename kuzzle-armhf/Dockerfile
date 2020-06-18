ARG TAG=2.2.2
FROM balenalib/armv7hf-debian-node:latest-jessie
# balenalib is formerly resin
# stretch and buster provide a compile error on boost-geospatial-index

LABEL io.kuzzle.vendor="Kuzzle <support@kuzzle.io>"
LABEL description="Run your Kuzzle backend in production mode"

ENV NODE_ENV=production

WORKDIR /var/app

RUN [ "cross-build-start" ]

RUN set -x \
  \
  && install_packages \
    build-essential \
    ca-certificates \
    curl \
    git \
    python \
    xz-utils

RUN npm install --global nodemon

# Get kuzzle and submodules
RUN git clone -b ${TAG} --recursive \
    https://github.com/kuzzleio/kuzzle.git .

# Debug line
# Crashing (out of memory)
#RUN npm install boost-geospatial-index

# Build kuzzle
RUN npm ci --unsafe-perm \
  && for plugin in plugins/enabled/*/; do \
      cd $plugin; \
      npm ci --unsafe-perm; \
     done

# Cleanup
RUN apt-get remove \
    build-essential \
    git \
    python \
    xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/var/app/docker-compose/scripts/docker-entrypoint.sh"]

RUN [ "cross-build-end" ]

CMD [ "nodemon", "--inspect=0.0.0.0:9229", "bin/start-kuzzle-server" ]

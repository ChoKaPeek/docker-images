FROM balenalib/armv7hf-debian-node:latest-buster
# balenalib is formerly resin
# buster for gcc-8

ARG current_tag=2.2.2

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
    nodemon \
    python \
    xz-utils

# Get kuzzle and submodules
RUN git clone -b ${current_tag} --recursive \
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
    build-essentials \
    git \
    python \
    xz-utils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/var/app/docker-compose/scripts/docker-entrypoint.sh"]

RUN [ "cross-build-end" ]

CMD [ "nodemon", "--inspect=0.0.0.0:9229", "bin/start-kuzzle-server" ]

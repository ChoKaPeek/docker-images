#!/bin/sh
# By ChoKaPeek <amael.tardif@epita.fr>

# server side
echo '{"experimental":true}' | sudo tee /etc/docker/daemon.json
# client side
echo '{"experimental":"enabled"}' | sudo tee $HOME/.docker/config.json
docker -v
sudo systemctl restart docker

#!/bin/sh

# installs the docker-credential-pass credentials helper
curl -fsSL https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz | tar xz
chmod +x docker-credential-pass
sudo mv docker-credential-pass /usr/local/bin/

# fixes Inappropriate ioctl issues with gpg2
echo 'allow-loopback-pinentry' >> ~/.gnupg/gpg-agent.conf

# runs gpg agent
echo RELOADAGENT | gpg-connect-agent

# fixes gpg2 generation hanging infinitely
sudo rngd -r /dev/urandom

# key generation, use batch mode (no input required)
gpg2 --pinentry-mode=loopback --gen-key --batch --status-fd=0 --with-colons ci/gpg_batch_file

# terminate rngd
sudo pkill rngd

# pass initialization, key usage
# `pass insert` disables by default the keyword echo without the option -e
pass init "Amael Tardif"
echo "pass is initialized" | pass insert -e docker-credential-helpers/docker-pass-initialized-check

# check if correctly initialized
gpg2 --list-secret-keys
# output : pass is initialized
pass show docker-credential-helpers/docker-pass-initialized-check
# output : {}
docker-credential-pass list

# config docker
mkdir -p ~/.docker
echo -n '{\n\t"credsStore": "pass"\n}' > ~/.docker/config.json

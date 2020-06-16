#!/bin/sh

# installs the docker-credential-pass credentials helper
curl -fsSL https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz | tar xz
chmod +x docker-credential-pass
sudo mv docker-credential-pass /usr/local/bin/

# fixes Inappropriate ioctl issues with gpg2
echo -n 'use-agent\npinentry-mode loopback\n' >> ~/.gnupg/gpg.conf
echo 'allow-loopback-pinentry' >> ~/.gnupg/gpg-agent.conf

# runs gpg agent
echo RELOADAGENT | gpg-connect-agent

# fixes gpg2 generation hanging infinitely
sudo rngd -r /dev/urandom

# key generation
gpg --batch --gen-key <<-EOF
%echo Generating a standard key
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: Amael Tardif
Name-Email: amael.tardif@epita.fr
Expire-Date: 0
# Do a commit here, so that we can later print "done" :-)
%commit
%echo done
EOF

pass init "Amael Tardif"

# config docker
mkdir -p ~/.docker
echo -n '{\n\t"credsStore": "pass"\n}' > ~/.docker/config.json

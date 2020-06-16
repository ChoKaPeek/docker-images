#!/bin/sh

curl -fsSL https://github.com/docker/docker-credential-helpers/releases/download/v0.6.3/docker-credential-pass-v0.6.3-amd64.tar.gz | tar xz
chmod +x docker-credential-pass
sudo mv docker-credential-pass /usr/local/bin/
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
key=$(gpg --no-auto-check-trustdb --list-secret-keys | grep ^sec | cut -d/ -f2 | cut -d" " -f1)
pass init $key
mkdir -p ~/.docker
touch ~/.docker/config.json
sed -i '0,/{/s/{/{\n\t"credsStore": "pass",/' ~/.docker/config.json

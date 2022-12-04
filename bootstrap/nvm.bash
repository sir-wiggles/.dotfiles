#! /bin/bash
set -e

pushd /tmp
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.bashrc
nvm install v16.14.0
popd

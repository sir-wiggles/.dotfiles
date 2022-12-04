#! /bin/bash
set -e

pushd /tmp
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo apt install ./ripgrep_13.0.0_amd64.deb
popd

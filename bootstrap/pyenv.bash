#! /bin/bash
set -e

sudo apt update
sudo apt install -y \
    build-essential  \
    curl             \
    libbz2-dev       \
    libffi-dev       \
    liblzma-dev      \
    libncursesw5-dev \
    libreadline-dev  \
    libsqlite3-dev   \
    libssl-dev       \
    libxml2-dev      \
    libxmlsec1-dev   \
    llvm             \
    make             \
    tk-dev           \
    wget             \
    xz-utils         \
    zlib1g-dev

pushd /tmp
curl https://pyenv.run | bash
source ~/.bashrc
popd

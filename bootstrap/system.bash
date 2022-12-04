#! /bin/bash
set -e

sudo apt update
sudo apt upgrade -y
sudo apt install -y \
    bat     \
    clang   \
    curl    \
    fd-find \
    g++     \
    git     \
    make    \
    stow    \
    tmux    \
    tree    \
    xsel

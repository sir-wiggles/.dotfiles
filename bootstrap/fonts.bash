#! /bin/bash
set -e

pushd /tmp
curl -L -O https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Agave.zip
unzip -o Agave.zip -d ~/.local/share/fonts -x LICENSE *.md *Windows*
fc-cache -f -v
popd

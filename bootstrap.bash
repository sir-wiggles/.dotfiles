#! /bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install make curl git tmux neovim jump ripgrep

# ==================== kitty ====================
pushd /tmp
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
popd

# ===================== fzf =====================
pushd /tmp
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
popd

# ===================== rg ======================
pushd /tmp
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo dpkg -i ripgrep_13.0.0_amd64.deb
popd

# ===================== go ======================
pushd /tmp
curl -LO https://go.dev/dl/go1.19.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
popd

# ==================== pyenv ====================
pushd /tmp
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
cd ~/.pyenv && src/configure && make -C src
popd

# ===================== nvm =====================
pushd /tmp
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install v16.14.0
popd

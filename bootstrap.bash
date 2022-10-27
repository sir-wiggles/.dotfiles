#! /bin/bash

sudo apt update
sudo apt upgrade -y
sudo apt install -y make curl git tmux bat tree stow gnome-tweaks clang g++ xsel

# =================== neovim ====================
pushd /tmp
curl -LO https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb
sudo apt install ./nvim-linux64.deb
popd

# ==================== kitty ====================
pushd /tmp
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
popd

# ===================== fzf =====================
pushd /tmp
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
yes | ~/.fzf/install
popd

# ===================== rg ======================
pushd /tmp
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
sudo apt install ./ripgrep_13.0.0_amd64.deb
popd

# ===================== go ======================
pushd /tmp
curl -LO https://go.dev/dl/go1.19.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.19.linux-amd64.tar.gz
popd

# ==================== pyenv ====================
pushd /tmp
curl https://pyenv.run | bash
source ~/.bashrc
popd

# ===================== nvm =====================
pushd /tmp
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.bashrc
nvm install v16.14.0
popd

# ==================== jump =====================
go install github.com/gsamokovarov/jump@latest

# ===================== tpm =====================
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

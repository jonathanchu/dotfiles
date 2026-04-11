#!/usr/bin/env bash
#
# Fedora-specific package installation and setup.
# Called from install.sh on Fedora systems.

set -e

echo "####### updating system"
sudo dnf update -y

echo "####### installing packages via dnf"
sudo dnf install -y \
  neovim \
  emacs \
  fish \
  git \
  git-lfs \
  ripgrep \
  bat \
  btop \
  jq \
  tmux \
  gh \
  gnupg2 \
  golang \
  gcc \
  gcc-c++ \
  make \
  cmake \
  libtool \
  unzip \
  curl \
  fontconfig \
  texlive-moderncv \
  texlive-fontawesome5 \
  texlive-multirow \
  texlive-arydshln

# Install Ghostty via Terra repo
if ! command -v ghostty &>/dev/null; then
  echo "####### adding Terra repo and installing Ghostty"
  sudo dnf install -y --nogpgcheck \
    --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
    terra-release
  sudo dnf install -y ghostty
else
  echo "Ghostty already installed, skipping."
fi

# Install JetBrains Mono Nerd Font
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
  echo "####### installing JetBrains Mono Nerd Font"
  mkdir -p ~/.local/share/fonts
  cd /tmp
  curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
  mkdir -p JetBrainsMono && tar -xf JetBrainsMono.tar.xz -C JetBrainsMono
  cp JetBrainsMono/*.ttf ~/.local/share/fonts/
  fc-cache -fv
  rm -rf JetBrainsMono JetBrainsMono.tar.xz
  cd -
else
  echo "JetBrains Mono Nerd Font already installed, skipping."
fi

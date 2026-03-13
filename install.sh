#!/usr/bin/env bash
#
# This installation is destructive, as it removes existing files/directories.
# Use at your own risk.
#
# Taken from https://github.com/mitchellh/dotfiles/blob/master/install.sh

# Symlink a source to a target, removing any existing file/symlink/directory
link_file() {
  local src="$1"
  local target="$2"

  if [ -h "$target" ]; then
    rm "$target"
  elif [ -d "$target" ]; then
    rm -rf "$target"
  elif [ -f "$target" ]; then
    rm "$target"
  fi

  ln -s "$src" "$target"
  echo "Linked $src to $target."
}

# Symlink top-level dotfiles and directories
for name in *; do
  if [ "$name" == "README.md" ] || \
     [ "$name" == "install.sh" ] || \
     [ "$name" == "config" ] || \
     [ "$name" == "LICENSE" ] || \
     [ "$name" == "Brewfile" ] || \
     [ "$name" == "npm-globals.sh" ] || \
     [ "$name" == "get_ghostty_themes.sh" ] || \
     [ "$name" == "osx_emacs_keybindings.dict" ] || \
     [ "$name" == "fedora-setup.sh" ]; then
    continue
  fi

  target="$HOME/.$name"

  if [ "$name" == "bin" ]; then
    target="$HOME/$name"
  fi

  link_file "$PWD/$name" "$target"
done

# Symlink XDG config directories (~/.config/<app>)
if [ -d "config" ]; then
  mkdir -p "$HOME/.config"
  for app in config/*; do
    app_name="$(basename "$app")"
    link_file "$PWD/$app" "$HOME/.config/$app_name"
  done
fi

# OS-specific setup
if [[ "$(uname)" == "Darwin" ]]; then
  echo "####### macOS detected"

  # Bootstrap the environment
  sudo xcodebuild -license accept

  echo "####### installing homebrew"
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew already installed, skipping."
  fi

  echo "####### homebrewing the world"
  brew bundle --global

  echo "####### installing custom osx keybindings"
  mkdir -p ~/Library/KeyBindings
  link_file "$PWD/osx_emacs_keybindings.dict" ~/Library/KeyBindings/DefaultKeyBinding.dict

elif [[ "$(uname)" == "Linux" ]]; then
  echo "####### Linux detected"

  # Detect distro
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
  fi

  if [[ "$DISTRO" == "fedora" ]]; then
    echo "####### Fedora detected"
    bash "$PWD/fedora-setup.sh"
  fi
fi

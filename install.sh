#!/usr/bin/env bash
#
# This installation is destructive, as it removes exisitng files/directories.
# Use at your own risk.
#
# Taken from https://github.com/mitchellh/dotfiles/blob/master/install.sh

for name in *; do
  if [ ! $name == "README.md" -a ! $name == "install.sh" ]; then
    target="$HOME/.$name"

    if [ $name == "bin" ]; then
      target="$HOME/$name"
    fi

    if [ -h $target ]; then
      rm $target
    elif [ -d $target ]; then
      rm -rf $target
    fi

    ln -s "$PWD/$name" "$target"
    echo "Linked $PWD/$name to $target."
  fi
done

# Bootstrap the environment
sudo /usr/bin/xcodebuild -license

echo "####### installing homebrew"
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "####### installing git"
brew install git

echo "####### homebrewing the world"
bash ~/.brew

echo "####### python"
pip install -U pip
pip install -r ~/.requirements.txt

echo "####### installing pipsi"
curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | python2.7
~/.pipsi

echo "####### installing jshint globally via npm"
npm install -g jshint

echo "####### fixing osx"
bash ~/.osx

echo "####### installing custom osx keybindings"
mkdir -p ~/Library/KeyBindings
ln -s $PWD/osx_emacs_keybindings.dict ~/Library/KeyBindings/DefaultKeyBinding.dict

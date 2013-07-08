# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="atmospheres"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git svn mercurial autojump python pip github vagrant brew)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

NODE_PATH="/usr/local/lib/node_modules"
export NODE_PATH

PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/usr/X11/bin:/usr/local/share/python:/Applications/Postgres.app/Contents/MacOS/bin:/Users/jonathan/.rvm/bin:/Users/jonathan/.rvm/gems/ruby-2.0.0-p247/bin:$HOME/bin"
export PATH

BAT_CHARGE=batcharge.py
export BAT_CHARGE

unsetopt correct_all


# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

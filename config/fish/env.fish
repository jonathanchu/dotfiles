set -gx WORKON_HOME ~/.virtualenvs
set -gx PYTHONPATH ~/.local/bin
set -gx ANSIBLE_NOCOWS 1

append-to-path ~/.local/bin

# Nvm {{{

function nvm
    # NOTE: nvm does not support Fish shell, so we we'll have to wrap it in the
    # "bass" utility, which allows execution of classic Bash shell scripts,
    # which monitors for any changed environment variables, and applies these
    # to the Fish shell env.
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

# }}}

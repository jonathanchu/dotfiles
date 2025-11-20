. ~/.config/fish/aliases.fish

set -gx fish_greeting ''

function fish_prompt
    set last_status $status

    echo ' '

    set user (whoami)

    set_color magenta
    printf '%s' $user
    set_color normal
    printf ' at '

    set_color yellow
    printf '%s' (hostname -s)
    set_color normal
    printf ' in '

    set_color $fish_color_cwd
    # printf '%s' (echo $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||')
    printf '%s' (prompt_pwd | sed -e "s|^$HOME|~|" -e 's|^/private||')
    set_color normal

    git_prompt
    virtualenv_prompt

    set_color normal
    printf ' (%s) ' (date +%H:%M)
    parse_git_dirty
    echo

    if test $last_status -ne 0
        set_color white -o
        printf '[%d] ' $last_status
        set_color normal
    end
    printf '$ '

    set_color normal
end

function git_current_branch -d 'Prints a human-readable representation of the current branch'
    set -l ref (git symbolic-ref HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
    if test -n "$ref"
        echo $ref | sed -e s,refs/heads/,,
        return 0
    end
end

function git_prompt
    if git rev-parse --show-toplevel >/dev/null 2>&1
        set_color normal
        printf ' on '
        set_color magenta
        printf '%s' (git_current_branch)
        set_color green
        set_color normal
    end
end

function parse_git_dirty
    if git rev-parse --show-toplevel >/dev/null 2>&1
        if test (git status 2> /dev/null 2>&1 | tail -n1) != "nothing to commit, working tree clean"
            set_color red
            printf '(!)'
            set_color normal
        else
            set_color green
            printf '(\u2714)'
            set_color normal
        end
    end
end

function virtualenv_prompt
    if [ -n "$VIRTUAL_ENV" ]
        printf ' inside '
        set_color yellow
        printf '%s ' (basename "$VIRTUAL_ENV")
        set_color normal
    end
end

set -gx EDITOR emacsclient -t
set -gx VISUAL emacsclient -c -a emacs

if status --is-login
    . ~/.config/fish/env.fish
end

if status --is-interactive
    . ~/.config/fish/private.fish
end

set POSTGRES_ROOT /Applications/Postgres.app/Contents/Versions/latest/bin
set PATH /usr/local/bin /usr/local/sbin $HOME/.local/bin $HOME/.cargo/bin $HOME/bin /opt/homebrew/bin $POSTGRES_ROOT $PATH

# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

set -gx PYTHONDONTWRITEBYTECODE 1

set -gx __fish_initialized 1

# eval (direnv hook fish)
direnv hook fish | source

test -e ~/.iterm2_shell_integration.fish
and source ~/.iterm2_shell_integration.fish

if not functions -q fisher
    set -q XDG_CONFIG_HOME
    or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# # tabtab source for serverless package
# # uninstall by removing these lines or running `tabtab uninstall serverless`
# [ -f /Users/jonathan/projects/simplecontacts.com/iris.js/postProcess/node_modules/tabtab/.completions/serverless.fish ]
# and . /Users/jonathan/projects/simplecontacts.com/iris.js/postProcess/node_modules/tabtab/.completions/serverless.fish
# # tabtab source for sls package
# # uninstall by removing these lines or running `tabtab uninstall sls`
# [ -f /Users/jonathan/projects/simplecontacts.com/iris.js/postProcess/node_modules/tabtab/.completions/sls.fish ]
# and . /Users/jonathan/projects/simplecontacts.com/iris.js/postProcess/node_modules/tabtab/.completions/sls.fish
# # tabtab source for slss package
# # uninstall by removing these lines or running `tabtab uninstall slss`
# [ -f /Users/jonathan/projects/simplecontacts.com/iris.js/postProcess/node_modules/tabtab/.completions/slss.fish ]
# and . /Users/jonathan/projects/simplecontacts.com/iris.js/postProcess/node_modules/tabtab/.completions/slss.fish

# Added by Antigravity
fish_add_path /Users/jonathan/.antigravity/antigravity/bin

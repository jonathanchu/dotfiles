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
    printf '%s' (echo $PWD | sed -e "s|^$HOME|~|" -e 's|^/private||')
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
  set -l ref (git symbolic-ref HEAD ^/dev/null; or git rev-parse --short HEAD ^/dev/null)
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
        if test (git status 2> /dev/null ^&1 | tail -n1) != "nothing to commit, working directory clean"
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

set -gx EDITOR emacs

if status --is-login
    . ~/.config/fish/env.fish
end

if status --is-interactive
   . ~/.config/fish/private.fish
end

set PATH /usr/local/bin /usr/local/sbin $PATH

set -gx PYTHONDONTWRITEBYTECODE 1

set -gx __fish_initialized 1

eval (direnv hook fish)

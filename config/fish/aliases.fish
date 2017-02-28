set LS_COLORS dxfxcxdxbxegedabagacad

function serve
        if test (count $argv) -ge 1
            if python -c 'import sys; sys.exit(sys.version_info[0] != 3)'
                /bin/sh -c "(cd $argv[1] && python -m http.server)"
            else
                /bin/sh -c "(cd $argv[1] && python -m SimpleHTTPServer)"
            end
        else
            python -m SimpleHTTPServer
        end
end

alias ls 'command ls -FG'
alias l ls
alias ll 'ls -la'
alias rm 'rm -i'
alias mv 'mv -i'
alias mkdir 'mkdir -p'
alias du 'du -kh'
alias df 'df -kh'

# Colorized cat (will guess file type based on contents)
alias ccat 'pygmentize -g'

alias pm 'python manage.py'
alias pmm 'python manage.py migrate'
alias pmmm 'python manage.py makemigrations'
alias pms 'python manage.py shell'
alias pmsp 'python manage.py shell_plus'
alias pmr 'python manage.py runserver'
alias ipn 'ipython notebook'
alias pmsm 'python manage.py showmigrations'
alias pmspnb 'python manage.py shell_plus --notebook'
alias pmmmn 'python manage.py makemigrations --name'
alias pmmmen 'python manage.py makemigrations --empty --name'

alias git hub
alias top 'glances'

alias pkill-emacs 'pkill -SIGUSR2 Emacs'

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

alias psql pgcli

alias gp='cd ~/projects/gitprime.com/GitPrime'

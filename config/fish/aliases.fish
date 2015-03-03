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
alias pms 'python manage.py shell_plus'
alias pmr 'python manage.py runserver'
alias ipn 'ipython notebook'

alias git hub
alias top 'glances'

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

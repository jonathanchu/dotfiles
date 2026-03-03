set LS_COLORS dxfxcxdxbxegedabagacad

if test (uname) = Darwin
    alias ls 'command ls -FG'
else
    alias ls 'command ls -F --color=auto'
end
alias l ls
alias ll 'ls -la'
alias rm 'rm -i'
alias mv 'mv -i'
alias mkdir 'mkdir -p'
alias du 'du -kh'
alias df 'df -kh'

alias top btop

alias pkill-emacs 'pkill -SIGUSR2 Emacs'

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'

alias cat 'bat --theme=TwoDark'

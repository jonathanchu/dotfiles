# fnm - Fast Node Manager
if command -q fnm
    fnm env | source
else if test -d "$HOME/.local/share/fnm"
    set PATH "$HOME/.local/share/fnm" $PATH
    fnm env | source
end

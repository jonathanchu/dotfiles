function serve --wraps='python3 -m http.server 8000' --description 'alias serve=python3 -m http.server 8000'
    python3 -m http.server 8000 $argv
end

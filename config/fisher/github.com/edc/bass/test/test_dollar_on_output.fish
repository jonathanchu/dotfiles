set root (dirname (status -f))/..
source $root/functions/bass.fish

bass source $root/test/fixtures/dollar_output.sh | grep -q 'some program output with the $ symbol in it'

echo (set_color green)Success(set_color normal)

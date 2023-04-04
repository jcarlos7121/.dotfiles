function ga; git add .; end
function gc; git commit -m $argv; end
function gp; git push $argv; end
function v; nvim $argv; end
function cat; bat $argv; end
function django; python manage.py $argv; end
function ibrew; arch -x86_64 /usr/local/bin/brew $argv; end

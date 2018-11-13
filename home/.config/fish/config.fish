set fish_greeting "" 
function datahub; ssh app@96.126.110.244; end
function app; google-chrome --app=http://$argv; end
function ares; killall xcompmgr; end
function res; nohup xcompmgr -cfF -t-9 -l-11 -r9 -o.95 -D6 &; end
function proglabs; ssh dokku@proglabs.co $argv; end
function ga; git add .; end
function gc; git commit -m $argv; end
function gp; git push $argv; end
function gpp; git push proglabs master; end
function memcached-flush; echo 'flush_all' | nc localhost 11211; end
function byte; sudo pm-hibernate; end
function bayi; sudo pm-suspend-hybrid; end
function pgc; sudo pg_ctlcluster 9.4 main $argv; end
function v; docker exec -ti eve /bin/bash; end
function django; python manage.py $argv; end
export EDITOR=vim

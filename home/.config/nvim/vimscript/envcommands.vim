fun! Nodenv( arg ) "{{{
  execute '!nodenv ' . a:arg
endfunction "}}}

fun! Exenv( arg ) "{{{
  execute '!exenv ' . a:arg
endfunction "}}}

fun! Pyenv( arg ) "{{{
  execute '!pyenv ' . a:arg
endfunction "}}}

fun! Fs( arg ) "{{{
  Start foreman start
endfunction "}}}

fun! Redis( arg ) "{{{
  Start redis-server
endfunction "}}}

fun! Pry( arg ) "{{{
  Start pry-remote
endfunction "}}}

fun! Rsb( arg ) "{{{
  Rails s -b 0.0.0.0
endfunction "}}}

fun! Guard( arg ) "{{{
  Start guard -P livereload
endfunction "}}}

fun! Heroku( arg ) "{{{
  execute 'TermExec cmd="heroku ' . a:arg . '" size=15 direction=float'
endfunction "}}}

fun! Dock( arg ) "{{{
  execute 'Dispatch docker-compose run --rm web ' . a:arg
endfunction "}}}

fun! Django( arg ) "{{{
  execute 'Start python manage.py ' . a:arg
endfunction "}}}

fun! Bundle( arg ) "{{{
  execute 'Dispatch bundle ' . a:arg
endfunction "}}}

fun! Av( cmd ) "{{{
  execute 'Dispatch av ' . a:cmd
endfunction "}}}

command! -nargs=* Fs call Fs( '<args>' )"}}}"
command! -nargs=* Pry call Pry( '<args>' )"}}}"
command! -nargs=* Redis call Redis( '<args>' )"}}}"
command! -nargs=* Exenv call Exenv( '<args>' )"}}}"
command! -nargs=* Pyenv call Pyenv( '<args>' )"}}}"
command! -nargs=* Nodenv call Nodenv( '<args>' )"}}}"
command! -nargs=* Rsb call Rsb( '<args>' )"}}}"
command! -nargs=* Guard call Guard( '<args>' )"}}}"
command! -nargs=* Dock call Dock( '<args>' )"}}}"
command! -nargs=* Django call Django( '<args>' )"}}}"
command! -nargs=* Heroku call Heroku( '<args>' )"}}}"
command! -nargs=* Bundle call Bundle( '<args>' )"}}}"
command! -nargs=* Av call Av( '<args>' )"}}}"

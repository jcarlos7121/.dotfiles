function fish_prompt --description 'Write out the prompt'
	set -l home_escaped (echo -n $HOME | sed 's/\//\\\\\//g')
   set -l pwd (echo -n $PWD | sed "s/^$home_escaped/~/" | sed 's/ /%20/g')
   set -l prompt_symbol ''
   switch $USER
       case root; set prompt_symbol '#'
       case '*';  set prompt_symbol '$'
   end
   set a (random)
   set b (math "$a % 6 + 31")
   switch $b
       case 31; set_color blue
       case 32; set_color green
       case 33; set_color 9d8000
       case 34; set_color cyan
       case 35; set_color blue
       case 36; set_color 9d8000
   end
   printf " [ %s  %s] %s " $USER $pwd $prompt_symbol
end

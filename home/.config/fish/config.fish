set fish_greeting ""

source  ~/.config/fish/functions/bash_include.fish
source  ~/.config/fish/functions/commands.fish

source ~/.config/fish/conf.d/asdf.fish
source ~/.config/fish/conf.d/fzf.fish

# Set up fzf key bindings
fzf --fish | source

# Set up jump
jump shell fish | source

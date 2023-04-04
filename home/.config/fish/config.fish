set fish_greeting ""

source  ~/.config/fish/functions/bash_include.fish
source  ~/.config/fish/functions/commands.fish

status --is-interactive; and source (rbenv init -|psub)
status --is-interactive; and source (nodenv init -|psub)

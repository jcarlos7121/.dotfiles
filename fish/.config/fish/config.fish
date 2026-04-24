# Auto-start tmux (skip when running as a Claude Code agent)
if status is-interactive; and not set -q TMUX; and not set -q CLAUDECODE
  tmux new-session -A -s filial -n workstation
end

set fish_greeting ""

source  ~/.config/fish/functions/bash_include.fish
source  ~/.config/fish/functions/commands.fish

source ~/.config/fish/conf.d/asdf.fish
source ~/.config/fish/conf.d/fzf.fish

# Skip heavy shell integrations for Claude Code agent panes (faster startup)
if not set -q CLAUDECODE
    fzf --fish | source
    jump shell fish | source
end

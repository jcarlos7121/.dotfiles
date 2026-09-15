# Auto-start herdr (skip when running as a Claude Code agent)
# Trial run — previous tmux auto-start kept below for easy rollback
if status is-interactive; and not set -q HERDR_ENV; and not set -q TMUX; and not set -q CLAUDECODE
  herdr --session filial
end
# if status is-interactive; and not set -q TMUX; and not set -q CLAUDECODE
#   tmux new-session -A -s filial -n workstation
# end

set fish_greeting ""

source  ~/.config/fish/functions/bash_include.fish
source  ~/.config/fish/functions/commands.fish

source ~/.config/fish/conf.d/fzf.fish

# mise is auto-activated by Homebrew's vendor_conf.d/mise-activate.fish

# Skip heavy shell integrations for Claude Code agent panes (faster startup)
if not set -q CLAUDECODE
    fzf --fish | source
    jump shell fish | source
end

# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<

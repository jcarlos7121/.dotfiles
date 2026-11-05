set fish_greeting ""

switch (uname)
  case Darwin
    source  ~/.config/fish/functions/bash_include.fish
    # mise is auto-activated by Homebrew's vendor_conf.d/mise-activate.fish
  case Linux
    # bash_include.fish imports the Mac ~/.bash_profile; set what applies here directly
    set -gx EDITOR nvim
    set -gx BUN_INSTALL $HOME/.bun
    fish_add_path $HOME/bin $BUN_INSTALL/bin
    type -q mise; and mise activate fish | source
end

source  ~/.config/fish/functions/commands.fish

test -f ~/.config/fish/conf.d/fzf.fish; and source ~/.config/fish/conf.d/fzf.fish

# Skip heavy shell integrations for Claude Code agent panes (faster startup)
if not set -q CLAUDECODE
    fzf --fish | source
    type -q jump; and jump shell fish | source
end

# >>> grok installer >>>
fish_add_path $HOME/.grok/bin
# <<< grok installer <<<

# Composio CLI
set --export PATH "$HOME/.local/bin" $PATH

# Auto-start herdr (skip when running as a Claude Code agent). Last, so the
# herdr server inherits the full PATH above (its key commands rely on it).
# Trial run — previous tmux auto-start kept below for easy rollback
if status is-interactive; and not set -q HERDR_ENV; and not set -q TMUX; and not set -q CLAUDECODE
  herdr --session filial
end
# if status is-interactive; and not set -q TMUX; and not set -q CLAUDECODE
#   tmux new-session -A -s filial -n workstation
# end

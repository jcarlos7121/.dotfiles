# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.pre.bash"
export PATH="$HOME/bin:$PATH"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export PATH="/Users/juanhinojo/Library/Python/3.9/bin:$PATH"

# MacPorts Installer addition on 2019-02-28_at_09:39:43: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export EDITOR=nvim
export PYTHON_CONFIGURE_OPTS="--enable-framework"

export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"

alias ibrew='arch -x86_64 /usr/local/bin/brew'

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(jump shell)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bash_profile.post.bash"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/juanhinojo/bin/google-cloud-sdk/path.bash.inc' ]; then . '/Users/juanhinojo/bin/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/juanhinojo/bin/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/juanhinojo/bin/google-cloud-sdk/completion.bash.inc'; fi

tmux

# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bash_profile.pre.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.pre.bash"

export PATH="$HOME/.anyenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export PATH="/Users/juanhinojo/Library/Python/3.9/bin:$PATH"

# MacPorts Installer addition on 2019-02-28_at_09:39:43: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

export EDITOR=nvim
export PYTHON_CONFIGURE_OPTS="--enable-framework"

alias ibrew='arch -x86_64 /usr/local/bin/brew'

eval "$(anyenv init -)"
eval "$(pyenv virtualenv-init -)"

tmux
# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bash_profile.post.bash" ]] && builtin source "$HOME/.fig/shell/bash_profile.post.bash"

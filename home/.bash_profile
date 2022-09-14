export PATH="$HOME/.anyenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export EDITOR=nvim
export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"

eval "$(anyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(erlenv init -)"
source "$HOME/.cargo/env"
tmux

##
# Your previous /Users/juanhinojo/.bash_profile file was backed up as /Users/juanhinojo/.bash_profile.macports-saved_2019-02-28_at_09:39:43
##

# MacPorts Installer addition on 2019-02-28_at_09:39:43: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

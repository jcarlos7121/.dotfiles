# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bash_profile.pre.bash" ]] && . "$HOME/.fig/shell/bash_profile.pre.bash"
export PATH="$HOME/.anyenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/bin/elasticsearch-6.0.1/bin:$PATH"
export PATH="$HOME/.emacs.d/bin:$PATH"
export EDITOR=nvim
export PYTHON_CONFIGURE_OPTS="--enable-framework"
eval "$(anyenv init -)"
export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
eval "$(pyenv virtualenv-init -)"
eval "$(erlenv init -)"
eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"
tmux

##
# Your previous /Users/juanhinojo/.bash_profile file was backed up as /Users/juanhinojo/.bash_profile.macports-saved_2019-02-28_at_09:39:43
##

# MacPorts Installer addition on 2019-02-28_at_09:39:43: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bash_profile.post.bash" ]] && . "$HOME/.fig/shell/bash_profile.post.bash"

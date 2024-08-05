#!/bin/zsh

cd
umask 002

# save tty state in a file where wsh can find it
if [ ! -f $HOME/.wshttymode ]
then
    stty -g > $HOME/.wshttymode
fi

if [ -f ~/.zshrc ]; then source ~/.zshrc; fi

# iterm2 integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Setup pyenv
if [ -d ~/.pyenv ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
fi

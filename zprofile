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

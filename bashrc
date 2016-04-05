#
# .bashrc:  sets up the bash environment 
#

# Read bash aliases and functions
[[ -f ~/.bash_functions ]] && . ~/.bash_functions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Done unless this is an interactive shell
[ -z "$PS1" ] && return

# Load additional bash init files
_load_bashrc_d

# This path may be appended, but do not change the original order
if [ -n "$SYSTYPE" ]; then
    prepend PATH $HOME/bin:/usr/local/sbin:/usr/local/bin
    [[ -n "$CONFIG_GUESS" ]] && prepend PATH $HOME/bin/$CONFIG_GUESS
else
    PATH=$PATH:$HOME/bin
fi

export PATH


#
# .bashrc:  sets up the bash environment 
#

# Read bash aliases and functions
[[ -f ~/.bash_functions ]] && . ~/.bash_functions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

# Add user bin and /usr/local to beginning of path
prepend PATH /usr/local/sbin:/usr/local/bin
prepend PATH $HOME/bin
export PATH

# Done unless this is an interactive shell
[ -z "$PS1" ] && return

# Load additional bash init files
_load_bashrc_d

# If set and it exists, add system type specific path 
[[ -n "$CONFIG_GUESS" && -d "$HOME/bin/$CONFIG_GUESS" ]] && prepend PATH $HOME/bin/$CONFIG_GUESS

export PATH


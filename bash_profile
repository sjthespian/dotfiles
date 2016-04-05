#
# .profile:  sets up the Bourne Shell environment 
#
# Workstation Model: IRIS 4D 
# Operating System:  IRIX 4.0.1
# Last Change Date:  December 18, 1991
#
# Local Modifications for NASA Lewis Research Center by Tony Facca 
#

cd
umask 002

stty erase '^H' kill '^U' intr '^C' echoe 

# some editor defaults
EXINIT='set noautoindent showmatch showmode autowrite redraw'
export EXINIT

# Set the TERM environment variable
if [ -d /usr/lib/terminfo ]
then
    eval `tset -s -Q`
fi

# save tty state in a file where wsh can find it
if [ ! -f $HOME/.wshttymode ]
then
    stty -g > $HOME/.wshttymode
fi

if [ -f ~/.bashrc ]; then source ~/.bashrc; fi


# Add local fonts
if [ -n "$DISPLAY" -a -d ~/.fonts ]; then
  xset +fp ~/.fonts
fi

# ChefVM init (https://github.com/trobrock/chefvm)
if [ -d ~/.chefvm ]; then
  eval "$(~/.chefvm/bin/chefvm init -)"
fi

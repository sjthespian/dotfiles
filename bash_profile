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

# save tty state in a file where wsh can find it
if [ ! -f $HOME/.wshttymode ]
then
    stty -g > $HOME/.wshttymode
fi

if [ -f ~/.bashrc ]; then source ~/.bashrc; fi

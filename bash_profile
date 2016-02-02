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

# list directories in columns
#ls () { /bin/ls -C $*; }

if [ -f ~/.bashrc ]; then source ~/.bashrc; fi


# If possible, start the windows system.  Give user a chance to bail out
#
#if [ `tty` != "/dev/console" -o $TERM != "sun" ]; then
#	:
#else
#
##    if ( ${?OPENWINHOME} == 0 ) then
##        setenv OPENWINHOME /usr/openwin
##    endif
#
##    echo -n "Starting OpenWindows (type Control-C to interrupt)"
##    sleep 5
##    $OPENWINHOME/bin/openwin
#
#    stty intr '^c'
#    echo -n "Starting X11R6 (type Control-C to interrupt)"
#    # Setup xauthority (the second is for gnuattach)
#    HOSTNAME=`hostname`
#    #cookie=`mkcookie.bin`
#    #xauth add $HOSTNAME:0 MIT-MAGIC-COOKIE-1 $cookie
#    #xauth add $HOSTNAME/unix:0 MIT-MAGIC-COOKIE-1 $cookie
#    cookie=`mkcookie.bin`
#    xauth add $HOSTNAME:999 MIT-MAGIC-COOKIE-1 $cookie
#    sleep 5
#
#    if [ "$?" = 0 ]
#    then
#	/usr/local/X11R6/bin/startx
#        fetchpop -q -l ~/.fetchpop.log	# Kill the fetchpop daemon on logout
#        clear_colormap		# get rid of annoying colourmap bug
#        clear			# get rid of annoying cursor rectangle
#        echo -n "Automatically logging out (type Control-C to interrupt)"
#        sleep 5
#        if [ "$?" = 0 ]
#        then
#            logout			# logout after leaving windows system
#        fi
#    fi
#fi

if [ -n "$DISPLAY" ]; then
  xset +fp ~/.fonts
fi

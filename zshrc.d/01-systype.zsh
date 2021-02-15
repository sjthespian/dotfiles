# Make sure this is only loaded once
if [ -n "${LOADED_01_SYSTYPE}" ]; then
  return
else
  LOADED_01_SYSTYPE=1
fi

# Try and figure out what kind of system we are on
if [ -e "$HOME/bin/config.guess" ]; then
    CONFIG_GUESS=`$HOME/bin/config.guess`
fi
case `uname -s` in
    "IRIX")	SYSTYPE=sgi
		;;
    "ULTRIX")	SYSTYPE=dec
		;;
    "SunOS")	SYSTYPE=sun
	case `uname -r` in
	    5*)
		prepend PATH /opt/gnu/bin
		append PATH /opt/local/bin:/usr/ucb:/usr/ccs/bin
	esac;;
    "AIX")	SYSTYPE=ibm
		;;
    "Linux")
		SYSTYPE="linux"
		append PATH /sbin:/usr/sbin
		# Synology synogear tools
		if [ -d /var/packages/DiagnosisTool/target/tool/ ]; then
		    prepend PATH /var/packages/DiagnosisTool/target/tool/
		fi
		;;
    "Darwin")
                SYSTYPE="mac"
                # Add homebrwew coreutils path
		if [ -d /usr/local/opt/coreutils ]; then
                    prepend PATH /usr/local/opt/coreutils/libexec/gnubin
                    #prepend MANPATH /usr/local/opt/coreutils/libexec/gnuman
		fi
		if [ -d /usr/local/sbin ]; then
                    append PATH /usr/local/sbin
		fi
                ;;
    *)		SYSTYPE="";;
esac

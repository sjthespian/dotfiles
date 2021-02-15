# Try and figure out what kind of system we are on
# check age of cached data, if over 30 days, regenerate
if [ -f $HOME/.config_guess ]; then
  now=$(date +%s)
  if [ -d /Applications ]; then # stat uses different flags on OSX
    modtime=$(/usr/bin/stat -f "%Sm" -t "%s" ~/.config_guess)
  else
    modtime=$(stat -c "%Y" ~/.config_guess)
  fi
  timeleft=$(( 30 - ( ($now - $modtime) / 60 / 60 ) ))
  if (( $timeleft > 0 )); then  # Less than 30 days old
    CONFIG_GUESS=$(cat ~/.config_guess)
  fi
fi
if [ -z  "$CONFIG_GUESS" -a -e "$HOME/bin/config.guess" ]; then
    CONFIG_GUESS=`$HOME/bin/config.guess`
    echo $CONFIG_GUESS > ~/.config_guess
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

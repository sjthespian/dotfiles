#
# .bashrc:  sets up the bash environment 
#

# Special DreamWorks bits
fqdn=`hostname -f`
location=''
if [ -x /usr/bin/facter ]; then
    location=`/usr/bin/facter location`
fi
case $fqdn in
    *dreamworks.*|*.ddu-india.com|*.pdi.com)
	# Get studio environment if not set
	if [ -z "$STUDIO" -a -n "$PS1" ]; then
  	    #echo "Loading /etc/profile..."
  	    . /etc/profile
  	    export STUDIO
	fi

	# Set default printer
	export PRINTER=dw917
	;;
esac

#
# prepend() and append() functions for path management
#
addtopath () { 
    eval value=\"\$$1\"
    case $3 in
	p*) result="$2:${value}" ;;
	*) case "$value" in
	    *:$2:*|*:$2|$2:*|$2) result="$value" ;;
	    "") result="$2" ;;
            *) result="${value}:$2"  ;;
	esac;;
    esac
    # Strip duplicate entries, '//', and '::' (and leading or trailing ':')
    result=`echo $result | awk -F: '{for (i=1; i<=NF; i++) {if (length($i) == 0) continue; if (a[$i] == 0) printf "%s:",$i; a[$i]++}}' | sed 's/:$//'`
    
    eval $1=$result
    unset result value
}

append () {
    addtopath $1 $2 append
}
prepend () {
    addtopath $1 $2 prepend
}

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
		append PATH /sbin:/usr/sbin;;
    "Darwin")
                SYSTYPE="mac"
                # Add homebrwew coreutils path
                prepend PATH /usr/local/opt/coreutils/libexec/gnubin
                prepend MANPATH /usr/local/opt/coreutils/libexec/gnuman
                append PATH /usr/local/sbin
                ;;
    *)		SYSTYPE="";;
esac

# History management - history by host
export HISTFILE=$HOME/.bash_history.`uname -n`
export HISTIGNORE="&:[bf]g:exit"

# Make less the default pager
export PAGER="less -m"

# Fix root's path - makes sure system directories are first
if [ `id -u` = "0" ]; then
    export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/local/sys/bin:/home/systems/bin:/usr/kerberos/bin:/usr/X11R6/bin"
fi

#
# Prompt setup
#
# Set the prompt, use color if possible
PS1PRE=''
if [ -n "$PS1" ]; then
    Bold="$(tput bold)"
    NoBold="$(tput sgr0)"
    
    # set a fancy prompt (non-color, unless we know we "want" color)
    case "$TERM" in
        xterm*|rxvt*|screen*|linux) color_prompt=yes;;
    esac
    
    # uncomment for a colored prompt, if the terminal has the capability; turned
    # off by default to not distract the user: the focus in a terminal window
    # should be on the output of commands, not on the prompt
    #force_color_prompt=yes
    
    if [ -n "$force_color_prompt" ]; then
        if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
            # We have color support; assume it's compliant with Ecma-48
            # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
            # a case would tend to support setf rather than setaf.)
            color_prompt=yes
        else
            color_prompt=
        fi
    fi

    # Figure out which site I'm at and set prompt color
    dwa_site='GLD'
    PS1COLOR='Magenta'
    if [ -n "$location" ]; then
        case $location in
            rwc)
                dwa_site='RWC'
                PS1COLOR='Green'
                ;;
            gld)
                dwa_site='DDU'
                PS1COLOR='Magenta'
                ;;
            ttp)
                dwa_site='DDU'
                PS1COLOR='Blue'
                ;;
        esac
    else
        case $fqdn in
	    *.rwc.dreamworks.net)
	        dwa_site='RWC'
	        PS1COLOR='Green'
	        ;;
	    *.odw.com.cn)
	        dwa_site='ODW'
	        PS1COLOR='Cyan'
	        ;;
	    *.ddu-india.com)
	        dwa_site='DDU'
	        PS1COLOR='Blue'
	        ;;
	    *.dreamworks.com|*.dreamworks.net)
	        dwa_site='DDU'
	        PS1COLOR='Magenta'
	        ;;
	    *.employees.org)
		dwa_site=''
	        PS1COLOR='Yellow'
	        ;;
	    *.lapseofthought.com)
		dwa_site=''
	        PS1COLOR='Cyan'
	        ;;
	    *)
	        dwa_site='unknown'
	        PS1COLOR='Blue'
	    ;;
        esac
    fi
    # If not color capable, use bold
    if [ "$color_prompt" != yes ]; then
	PS1COLOR='Bold'
    fi    
    
    # If this is an xterm, screen, or tmux set the title to user@host:dir
    case "$TERM" in
        xterm*|rxvt*)
            PS1PRE="\[\e]0;\u@\h: \w\a\]"
            ;;
        screen*)
	    PS1PRE="\[\ek\w\e\\]"
	    ;;
        iris-ansi|iris-ansi-net)
            #export PROMPT_COMMAND='echo -n -e "\033P1.y"${LOGNAME}@${HOST}:$PWD"\033\\"'
            #PS1="\[\eP1.y\u@\h: \w\a\]$PS1"
            ;;
        *)
            ;;
    esac

    # Get colors from git-bash-prompt module
    if [ -d ~/.bash-git-prompt ]; then
      source ~/.bash-git-prompt/prompt-colors.sh
    fi
    PSCOLOR=""
    if [ -n "$PS1COLOR" ];then
      eval PSCOLOR=\$$PS1COLOR
    fi

    # Special root prompt
    if [ "$UID" == "0" ]
    then
        if [ "$TERM" == "dumb" ]; then
            PS1="\h# "
        else
            if [ "$color_prompt" == yes ]; then
                PS1="${BrightRed}\h${ResetColor}# "
		PSCOLOR='BrightRed'
            else
                PS1="${Bold}\h# "
		PSCOLOR='Red'
            fi
        fi
   else
	# Regular prompt, simple prompt for dumb terminals
        if [ "$TERM" == "dumb" ]; then
            PS1="\u@\h> "
        else
            PS1="${PSCOLOR}\u@\h${ResetColor}> "
        fi
    fi

    if [ -n "$PS1PRE" ]; then
	PS1=${PS1PRE}${PS1}
    fi
    export PS1
    unset color_prompt force_color_prompt

    if [ -d ~/.bash-git-prompt ]; then
        # git prompt setup - https://github.com/magicmonty/bash-git-prompt
        # Also defines colors based on the theme
        # Set config variables first
        GIT_PROMPT_ONLY_IN_REPO=0

        # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

        # GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
        # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence
        GIT_PROMPT_START="${PS1PRE}(_LAST_COMMAND_INDICATOR_${ResetColor})${PSCOLOR}\u@\h${ResetColor}"
        GIT_PROMPT_END="> "

        # as last entry source the gitprompt script
        # GIT_PROMPT_THEME=Custom # use custom .git-prompt-colors.sh
        GIT_PROMPT_THEME=Solarized # use theme optimized for solarized color scheme

        # Load git prompt package config
        source ~/.bash-git-prompt/gitprompt.sh

	# Set up ${color} variables for later use
        # Fix colors for shell use (strip leading and trailing brackets)
        fixcolor () {
            c=$1
            eval esc=\$$c
            esclen=`expr ${#esc} - 4`
            esc=${esc:2:$esclen}
            eval $c='$esc'
        }
        fixcolor 'ResetColor'
        for i in 0 1 2 3 4 5 6 7; do
            fixcolor ${ColorNames[$i]}
        done
    fi
    
    # Fix bs/del mapping
    stty dec
fi

# This path may be appended, but do not change the original order
if [ -n "$SYSTYPE" ]; then
    prepend PATH $HOME/bin:/usr/local/sbin:/usr/local/bin
    if [ -n "$CONFIG_GUESS" ]; then
       prepend PATH $HOME/bin/$CONFIG_GUESS
    fi
else
    PATH=$PATH:$HOME/bin
fi

# Set default editor if emacs is available and not forwrding over ssh
if [ -n "$DISPLAY" ]; then
  DISPLAYISLOCALHOST=`echo "$DISPLAY" | grep -c localhost`;
  if [ -z "$DISPLAY" -o "$DISPLAYISLOCALHOST" -gt 0 ]; then
    :
  else
    if `which gnuclient > /dev/null 2>&1` && `gnuclient --batch -f 'emacs-version()' > /dev/null 2>&1`; then
      EDITOR=gnuclient
      VISUAL=gnuclient
    fi
    if `which emacsclient > /dev/null 2>&1` && `emacsclient -e 'emacs-version()' > /dev/null 2>&1`; then
      EDITOR=emacsclient
      VISUAL=emacsclient
    fi
  fi
fi

# Make sure we have systems bin
append PATH /home/systems/bin:/usr/local/sys/bin
# And other systems dirs
append PATH /opt/cxoffice/bin:/sbin:/usr/sbin

export PATH MANPATH EDITOR A1MAIL

# Read bash aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Make locally installed modules work
#   See ~/.pydistutils.cfg
#export PYTHONPATH=/home/drich/py-lib

## Load bash completion
#if [ -f "$HOME/etc/bash_completion" ]; then
#    . $HOME/etc/bash_completion
#fi

# Additional bash completion
#_personal_completion_loader()
#{
#    . "~/.bash_completion.d/$1.sh" >/dev/null 2>&1 && return 124
#    . "~/.bash_completion.d/$1.sh" >/dev/null 2>&1 && return 124
#}
#complete -D -F _personal_completion_loader

case $fqdn in
    *dreamworks.*|*.ddu-india.com|*.pdi.com)
        # Make ut_ticket work
        export PYTHON_INCLUDE_PATH=/rel/map/osa/python
        # Add additional OSA tools
        append PATH /usr/home/osa/scripts

        # Convert variables.csh to shell and source it
        if [ -f '/etc/profile.d/variables.csh' ]; then
          sed 's/setenv/export/;s/\(export [^ ]*\) /\1=/;s/^set/#set/' /etc/profile.d/variables.csh > /tmp/variables-$$.sh
          . /tmp/variables-$$.sh
          /bin/rm -f /tmp/variables-$$.sh
        fi

        # Get the /rel path for sys_hey and other utils
        if [ -f /rel/boot/env/softmap_path.default ]; then
          OIFS=$IFS
          IFS=:
          RELMAPDIRS=`cat /rel/boot/env/softmap_path.default`
          SOFTMAP_PATH=''
          for mapdir in $RELMAPDIRS; do
            IFS=$OIFS
            if [ -d "$mapdir/bin" ]; then
              append PATH $mapdir/bin
              append SOFTMAP_PATH $mapdir
            fi
            if [ -d "/rel/map/$mapdir/bin" ]; then
              append PATH /rel/map/$mapdir/bin
              append SOFTMAP_PATH /rel/map/$mapdir
            fi
            if [ -d "/rel/folio/pipeline/$mapdir/bin" ]; then
              append PATH /rel/folio/pipeline/$mapdir/bin
              append SOFTMAP_PATH /rel/folio/pipeline/$mapdir
            fi
            if [ -d "/rel/folio/jose/$mapdir/bin" ]; then
              append PATH /rel/folio/jose/$mapdir/bin
              append SOFTMAP_PATH /rel/folio/jose/$mapdir
            fi
          done
          IFS=$OIFS
          export SOFTMAP_PATH
        fi

        # Add Zenoss env on the zenoss servers
        if [ -d ~zenoss ]; then
          . ~zenoss/.bashrc
        fi
        ;;
esac

if [ -n "$PS1" ]; then
  stty erase ^h
fi

# Setup CD/DVD tools for OSX
if [ "$SYSTYPE" == "mac" ]; then
    export CDR_DEVICE=1,0,0
    export CDR_SPEED=40
    export CDR_FIFISIZE=2m
    alias cdrecord='sudo cdrecord --driveropts=burnfree -eject'
fi

# Ensure we have a working ssh-agent
check-ssh-agent() {
    [ -S "$SSH_AUTH_SOCK" ] && { ssh-add -l >& /dev/null || [ $? -ne 2 ]; }
}

# attempt to connect to a running agent
check-ssh-agent || export SSH_AUTH_SOCK=~/tmp/ssh-agent.sock
# if agent.env data is invalid, start a new one
check-ssh-agent || eval "$(ssh-agent -s -a ~/tmp/ssh-agent.sock)" > /dev/null

# Vagrant setup
export VAGRANT_HOME='/usr/pic1/vagrant.d'


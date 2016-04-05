#
# .bashrc:  sets up the bash environment 
#

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

# History management - history by host
export HISTFILE=$HOME/.bash_history.`uname -n`
export HISTIGNORE="&:[bf]g:exit"

# Make less the default pager
export PAGER="less -m"

# Fix root's path - makes sure system directories are first
#if [ `id -u` = "0" ]; then
#    export PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/local/sys/bin:/home/systems/bin:/usr/kerberos/bin:/usr/X11R6/bin"
#fi

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
        ansi|xterm*|rxvt*|screen*|linux)
	    export CLICOLOR=1
	    export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
	    color_prompt=yes;;
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
    site='PAL'
    PS1COLOR='Magenta'
    fqdn=`hostname -f`
    case $fqdn in
	PAL*)
	    site='PAL'
	    PS1COLOR='Green'
	    ;;
	BUR*)
	    site='ODW'
	    PS1COLOR='Cyan'
	    ;;
	BLR*)
	    site='BLR'
	    PS1COLOR='Blue'
	    ;;
	*.general.*)
	    site='CAN'
	    PS1COLOR='Magenta'
	    ;;
	*.compliant.*)
	    site='CAN'
	    PS1COLOR='BrightRed'
	    ;;
	CAN*)
	    site='CAN'
	    PS1COLOR='Magenta'
	    ;;
	*.employees.org)
	    site=''
	    PS1COLOR='Yellow'
	    ;;
	*.lapseofthought.com)
	    site=''
	    PS1COLOR='Cyan'
	    ;;
	*)
	    site='unknown'
	    PS1COLOR='Blue'
	;;
    esac

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
    if [ -e ~/.bash-git-prompt ]; then
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

    if [ -e ~/.bash-git-prompt ]; then
        # git prompt setup - https://github.com/magicmonty/bash-git-prompt
        # Also defines colors based on the theme
        # Set config variables first
        GIT_PROMPT_ONLY_IN_REPO=0

        # GIT_PROMPT_FETCH_REMOTE_STATUS=0   # uncomment to avoid fetching remote status

        # GIT_PROMPT_START=...    # uncomment for custom prompt start sequence
        # GIT_PROMPT_END=...      # uncomment for custom prompt end sequence
	if [ -d ~/.chefvm ]; then
	    GIT_PROMPT_START="${PS1PRE}(_LAST_COMMAND_INDICATOR_${ResetColor})${PSCOLOR}\u@\h${ResetColor}${Yellow}(\$(chefvm current))${ResetColor}"
	else
	    GIT_PROMPT_START="${PS1PRE}(_LAST_COMMAND_INDICATOR_${ResetColor})${PSCOLOR}\u@\h${ResetColor}"
	fi
        GIT_PROMPT_END="${BoldWhite}>${ResetColor} "

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
#        fixcolor 'ResetColor'
#        for i in 0 1 2 3 4 5 6 7; do
#            fixcolor ${ColorNames[$i]}
#        done
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

export PATH MANPATH EDITOR A1MAIL

# Read bash aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Load bash completion
if [ -f "$HOME/.bash_completion" ]; then
    . $HOME/.bash_completion
fi
# OSX
if [ "$SYSTYPE" == "mac" ]; then
    if [ brew --version >/dev/null 2>&1 -a -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
    fi
    # Git completion from xCode
    if [ -f /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash ]; then
        . /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
    fi
fi

# Additional bash completion
_personal_completion_loader() {
    for i in ~/.bash_completion.d/*.sh; do
        . $i >/dev/null 2>&1 || echo "WARNING: include of $script failed!"
    done
}
_personal_completion_loader
#_personal_completion_loader()
#{
#    . "~/.bash_completion.d/$1.sh" >/dev/null 2>&1 && return 124
#}
#complete -D -F _personal_completion_loader

if [ -n "$PS1" ]; then
  stty erase ^h
fi

# Ensure we have a working ssh-agent
check-ssh-agent() {
    [ -S "$SSH_AUTH_SOCK" ] && { ssh-add -l >& /dev/null || [ $? -ne 2 ]; }
}

# attempt to connect to a running agent
check-ssh-agent || export SSH_AUTH_SOCK=~/tmp/ssh-agent.sock
# if agent.env data is invalid, start a new one
check-ssh-agent || eval "$(ssh-agent -s -a ~/tmp/ssh-agent.sock)" > /dev/null

# Groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec

# Additional include files
if [ -d ~/.bashrc.d ]; then
    for script in ~/.bashrc.d/*.sh; do
	. $script >/dev/null 2>&1 || echo "WARNING: include of $script failed!"
    done
fi

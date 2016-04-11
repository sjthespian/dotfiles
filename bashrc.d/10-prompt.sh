#
# Prompt setup
#
# Set the prompt, use color if possible
PS1PRE=''
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
	site='LAS'
	PS1COLOR='Magenta'
	;;
    *.compliant.*)
	site='LAS'
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
	    PSCOLOR='BrightRed'
            eval PSCOLOR=\$$PSCOLOR
            PS1="${PSCOLOR}\u@\h${ResetColor}# "
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

    # If chefvm is installed, add it to the prompt
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
#    fixcolor 'ResetColor'
#    for i in 0 1 2 3 4 5 6 7; do
#        fixcolor ${ColorNames[$i]}
#    done
fi

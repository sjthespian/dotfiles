#
# Prompt setup
#
# Set the prompt, use color if possible
PS1PRE=''
PS1POST=''
# Find terminal commands, not avaialble on all systems
which tput > /dev/null 2>&1
if [ $? == 0 ]; then
  TPUT=$(which tput | head -1)
else
  TPUT=/bin/true
fi
Bold="$($TPUT bold)"
NoBold="$($TPUT sgr0)"
    
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    ansi|xterm*|rxvt*|screen*|tmux*|linux)
	export CLICOLOR=1
	export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
	color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x $TPUT ] && $TPUT setaf 1 >&/dev/null; then
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
	#PS1PRE="\[\ek\w\e\\\]"
        PS1PRE="\[\e]0;\u@\h: \w\a\]"
	stty erase ^?
	;;
    tmux*)
        #PS1PRE="\[\e]0;\u@\h: \w\a\]"
	PS1PRE="\[\e]2;\u@\h: \w\a\e\\\\\]"
	stty erase ^?
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
if [ -n "$PS1PRE" ]; then
    PS1=${PS1}${PS1POST}
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

    # If knife profiles are configured, use those
    # otherwise, if chefvm is installed, add it to the prompt
    GIT_PROMPT_START="${PS1PRE}(_LAST_COMMAND_INDICATOR_${ResetColor})${PSCOLOR}\u@\h${ResetColor}${PS1POST}"
    if [ -f ~/.chef/credentials ]; then
        GIT_PROMPT_START="${PS1PRE}(_LAST_COMMAND_INDICATOR_${ResetColor})${PSCOLOR}\u@\h${ResetColor}${Yellow}(\$(cat ~/.chef/context 2>/dev/null || echo "default"))${ResetColor}${PS1POST}"
    else
        if [ -d ~/.chefvm ]; then
            GIT_PROMPT_START="${PS1PRE}(_LAST_COMMAND_INDICATOR_${ResetColor})${PSCOLOR}\u@\h${ResetColor}${Yellow}(\$(chefvm current))${ResetColor}${PS1POST}"
        fi
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

# Temporary workaround for the interations defined in
# https://github.com/magicmonty/bash-git-prompt/issues/348
function setLastCommandState() {
  GIT_PROMPT_LAST_COMMAND_STATE=$__bp_last_ret_value
}

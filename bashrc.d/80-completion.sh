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
    for i in /usr/local/etc/bash_completion ~/.bash_completion.d/*.sh; do
	if [ -e $i ]; then
            . $i >/dev/null 2>&1 || echo "WARNING: include of $script failed!" 1>&2
	fi
    done
}
_personal_completion_loader
#_personal_completion_loader()
#{
#    . "~/.bash_completion.d/$1.sh" >/dev/null 2>&1 && return 124
#}
#complete -D -F _personal_completion_loader

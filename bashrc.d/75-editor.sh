# Set default editor if emacs is available and not forwrding over ssh
if [ -n "$DISPLAY" ]; then
    DISPLAYISLOCALHOST=`echo "$DISPLAY" | grep -c localhost`;
else
    DISPLAYISLOCALHOST=0
fi
if [ -z "$DISPLAY" -o "$DISPLAYISLOCALHOST" -gt 0 ]; then
    if `which emacs > /dev/null 2>&1` && `emacs --version > /dev/null 2>&1`; then
	EDITOR=emacs
	VISUAL=emacs
    fi
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

export EDITOR

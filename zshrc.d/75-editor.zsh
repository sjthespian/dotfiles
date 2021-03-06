# Make sure this is only loaded once
if [ -n "${LOADED_75_EDITOR}" ]; then
  return
else
  LOADED_75_EDITOR=1
fi

# some editor defaults
EXINIT='set noautoindent showmatch showmode autowrite redraw'
export EXINIT

# Set default editor if emacs is available and not forwrding over ssh
if [ -n "$DISPLAY" ]; then
    DISPLAYISLOCALHOST=`echo "$DISPLAY" | grep -c localhost`;
else
    DISPLAYISLOCALHOST=0
fi
# Don't worry about X11 any longer - drich 2020-Feb-07
#if [ -z "$DISPLAY" -o "$DISPLAYISLOCALHOST" -gt 0 ]; then
    if `which emacs > /dev/null 2>&1` && `emacs --version > /dev/null 2>&1`; then
	EDITOR=emacs
	VISUAL=emacs
    fi
#else
    if `which gnuclient > /dev/null 2>&1` && `gnuclient --batch -f 'emacs-version()' > /dev/null 2>&1`; then
	EDITOR=gnuclient -t
	VISUAL=gnuclient
    fi
    if `which emacsclient > /dev/null 2>&1` && `emacsclient -e 'emacs-version()' > /dev/null 2>&1`; then
	export ALTERNATE_EDITOR=""
	EDITOR="emacsclient -t"
	VISUAL=emc
    fi
#fi

export EDITOR VISUAL

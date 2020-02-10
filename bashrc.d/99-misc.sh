# Set the TERM environment variable
if [ -d /usr/lib/terminfo ]
then
    eval `tset -s -Q`
fi

# Fix bs/del mapping
stty dec
stty erase '^H' kill '^U' intr '^C' echoe 

# History management - history by host
export HISTFILE=$HOME/.bash_history.`uname -n`
export HISTIGNORE="&:[bf]g:exit"

# Make less the default pager
export PAGER="less -m"

# Add local fonts
if [ -n "$DISPLAY" -a -d ~/.fonts ]; then
  xset +fp ~/.fonts
fi

# Groovy
if [ -d /usr/local/opt/groovy/libexec ]; then
  export GROOVY_HOME=/usr/local/opt/groovy/libexec
fi

# ChefVM init (https://github.com/trobrock/chefvm)
if [ -d ~/.chefvm ]; then
  eval "$(~/.chefvm/bin/chefvm init -)"
fi

# Android SDK settings from brew
if [ -d /usr/local/opt/android-sdk ]; then
  export ANDROID_HOME=/usr/local/opt/android-sdk
fi

# Python
if [ -d ~/.virtualenvs ]; then
  export WORKON_HOME=$HOME/.virtualenvs
  source /usr/local/bin/virtualenvwrapper.sh
fi

# Go
which go > /dev/null 2>&1
if [ $? == 0 ]; then
  export GOPATH="${HOME}/go/"
  export PATH=$PATH:$GOPATH/bin
  # Make sure some common go utils are installed
  installgoutil() {
    if [ ! -f $GOPATH/bin/$1 ]; then
      go get $2
    fi
  }
  installgoutil godef github.com/rogpeppe/godef
  installgoutil gocode github.com/nsf/gocode
  installgoutil goimports golang.org/x/tools/cmd/goimports
  installgoutil guru golang.org/x/tools/cmd/guru
fi

# JAVA_HOME settings on the Mac
if [ -d /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/ ]; then
  export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/
fi

# Syntax highlighting in less on OSX
# http://funkworks.blogspot.com/2013/01/syntax-highlighting-in-less-on-osx.html
if `hash src-hilite-lesspipe.sh > /dev/null 2>&1`; then
  LESSPIPE=`which src-hilite-lesspipe.sh`
  if [ -n "$LESSPIPE" ]; then
    export LESSOPEN="| ${LESSPIPE} %s"
    export LESS='-R'
  fi
fi

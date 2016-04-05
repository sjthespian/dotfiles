# History management - history by host
export HISTFILE=$HOME/.bash_history.`uname -n`
export HISTIGNORE="&:[bf]g:exit"

# Make less the default pager
export PAGER="less -m"

# Fix bs/del mapping
stty dec
stty erase ^h

# Groovy
export GROOVY_HOME=/usr/local/opt/groovy/libexec

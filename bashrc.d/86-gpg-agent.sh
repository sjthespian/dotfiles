# Use cached gpg-agent data if it exists, otherwise start a new agent

AGENTOPTS='--enable-ssh-support'

# See if we have pinentry
# Special case for mac
PINENTRY=`which pinentry-mac`
[[ -z "$PINENTRY" ]] && PINENTRY=`which pinentry`
if [ -n "$PINENTRY" ]; then
    AGENTOPTS="${AGENTOPTS} --pinentry-program $PINENTRY"
fi

[ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
  export GPG_AGENT_INFO
else
  eval $( gpg-agent --daemon ${AGENTOPTS} --write-env-file ~/.gpg-agent-info )
fi

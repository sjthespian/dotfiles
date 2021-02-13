# Use cached gpg-agent data if it exists, otherwise start a new agent

# Make sure we have gpg-agent
which gpg-agent> /dev/null 2>&1
if [ $? == 0 ]; then
    AGENTOPTS='--enable-ssh-support --disable-scdaemon'

    # See if we have pinentry
    # Special case for mac
    PINENTRY=`type pinentry-mac 2>/dev/null | awk '{print $3}'`
    [[ -z "$PINENTRY" ]] && PINENTRY=`which pinentry`
    if [ -n "$PINENTRY" ]; then
        AGENTOPTS="${AGENTOPTS} --pinentry-program $PINENTRY"
    fi

    [ -f ~/.gpg-agent-info ] && source ~/.gpg-agent-info
    if [ -S "${GPG_AGENT_INFO%%:*}" ]; then
      export GPG_AGENT_INFO
    else
    #  eval $( gpg-agent --daemon ${AGENTOPTS} --write-env-file ~/.gpg-agent-info )
      eval $( gpg-agent --daemon ${AGENTOPTS} > ~/.gpg-agent-info )
    fi
else
    echo "NOTICE: No gpg-agent found, ssh and gpg key management not available"
fi

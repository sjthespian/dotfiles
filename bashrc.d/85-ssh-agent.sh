# Ensure we have a working ssh-agent
check-ssh-agent() {
    [ -S "$SSH_AUTH_SOCK" ] && { ssh-add -l >& /dev/null || [ $? -ne 2 ]; }
}

# attempt to connect to a running agent
check-ssh-agent || export SSH_AUTH_SOCK=~/tmp/ssh-agent.sock
# if agent.env data is invalid, start a new one
check-ssh-agent || eval "$(ssh-agent -s -a ~/tmp/ssh-agent.sock)" > /dev/null


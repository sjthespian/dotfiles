#!/bin/bash

# interactively remove file -- good for beginners
alias rm='rm -i'

alias ?='man man'
alias ls='ls -CF'
alias list='more -l'
alias wa='who -a'
alias h='history'
alias lo='logout'
gnomeopen=`which gnome-open 2>/dev/null`
if [ -n "`which gnome-open 2>/dev/null`" ]; then
  alias open='gnome-open'
fi
if [ -x /usr/bin/vim ]; then
  alias vi=vim
fi

# Use the Berkeley Mail program
alias mail='Mail'

alias al='ls -al'
alias su='su -'

# logout alias
alias bye='clear; logout'

# Strip all comments from a file and display it
alias stripcomments="sed 's/#.*$//;/^[ 	]*$/d' $*"

# Monit summary failed services
alias monitbad="sudo monit summary | egrep -v 'Accessible|Running'"

# X11 Auth update
#rxauth() { xauth extract - `uname -n`:0 | rsh $* xauth merge - }
# Setup root xauth
rootxauth () {
  export XAUTHORITY=$HOME/.Xauthority
  chmod a+r $XAUTHORITY
}

# Xterm aliases
settitle () {
  echo -n -e "\033]2;$*\007"
}
seticonname () {
  echo -n -e "\033]1;$*\007"
}

alias wake_dream="sudo ether-wake 00:60:08:20:CF:34"

# Compiz startup -- update in /usr/bin/compiz-gtk
function runCompiz() {
    gtk-window-decorator &
#    exec compiz –ignore-desktop-hints glib gconf gnomecompat $@
    exec compiz --replace --sm-disable --indirect-rendering --ignore-desktop-hin
ts ccp glib gconf gnomecompat $@ &
#    exec compiz --replace --sm-disable --loose-binding --ignore-desktop-hints c
cp glib gconf gnomecompat $@ &
}

# Configure chef dev environment
alias chefdk='eval "$(chef shell-init bash)"'

# JSON
function jsonlint() {
  if [ -f "$1" ]; then
    python -mjson.tool < $1 > /dev/null
  else
    python -mjson.tool > /dev/null
  fi
}
function jsonpp() {
  if [ -f "$1" ]; then
    python -mjson.tool < $1
  else
    python -mjson.tool
  fi
}

# SSH forwarding
endforward() {
  pids=`ps -efww| egrep 'ssh.*morpheus-forward' | egrep -v grep | awk '{print $2}'`
  if [ -n "$pids" ]; then
    kill $pids
  fi
}
alias homeforward='endforward && ssh -f -N morpheus-forward && echo "Proxy started"'
alias homeproxyforward='endforward && ssh -f -N morpheus-forward-proxy && echo "Proxy started"'

fixssh() {
  if [ -z "$1" ]; then
    echo "usage: fixssh [user@]host"
  fi
  # deal with user@host
  IFS=@ read sshuser sshhost <<< "$1"
  if [ -z "$sshhost" ]; then
    sshhost=$sshuser
    sshuser=''
  fi
  sshfqdn=`host $sshhost | awk '{print $sshhost}'`
  sshaddr=`host $sshhost | awk '{print $NF}'`
  #sshhost=`nslookup $1 | sed -n '/Name:/,/Address:/p' | awk '{print $2}'`
  for sshhostall in $sshhost $sshfqdn $sshaddr; do
    exists=`ssh-keygen -F $sshhostall | wc -c`
    if [ "$exists" != 0 ]; then
      echo $sshhostall | sed 's/,/ /g' | xargs -n1 ssh-keygen -R
    fi
  done
  if [ -n "$sshuser" ]; then
    ssh $sshuser@$sshfqdn
  else
    ssh $sshfqdn
  fi
}
alias sshnokey='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'
sshinstallkeys() {
  if [ -z "$1" ]; then
    echo "usage: sshinstallkeys hostname"
  else
    if [ -x '/usr/bin/ssh-copy-id' ]; then
      echo "$1..." && ssh-copy-id -oConnectionAttempts=1 -oConnectTimeout=10 -oStrictHostKeyChecking=no $1
    else
      echo "$1..." && cat ~/.ssh/id_dsa.pub | ssh -oConnectionAttempts=1 -oConnectTimeout=10 -oStrictHostKeyChecking=no $1 "umask 077 && mkdir ~/.ssh 2>/dev/null; cat >> ~/.ssh/authorized_keys"
    fi
  fi
}

if [ -n "`which xxdiff 2>/dev/null`" ]; then
  alias xdiff="xxdiff"
fi

# Larger window for rdesktop
#alias rdesktop='rdesktop -g1152x768'
alias rdesktop='rdesktop -a16 -g1280x1024'

# VNC is vinagre
if [ -n "`which vinagre 2>/dev/null`" ]; then
  alias vncviewer="vinagre"
fi
# Start/stop remove VNC
# General host start/stop
vncstart () {
  ssh -f -n $1 x11vnc -display :0 -many -bg  && sleep 5 && vncviewer -geometry +0+0 $1
}
vncstop () {
  ssh -f -n $1 killall x11vnc
}

# Remote connection aliasts
alias morpheus-con='ssh -f -L5909:morpheus-con:5900 morpheus.lapseofthought.com sleep 10; vncviewer localhost:9'
alias destiny-con='ssh -f -L5908:destiny-con:5900 voip.lapseofthought.com sleep 10; vncviewer localhost:8'

# Forward an SSH port for thye specified time
# usage sshforward host port [time]
#   por tmay eitehr be a single port or a port:host:port triplet
sshportforward() {
  host=$1
  port=$2
  time=$3
  if `echo $port | grep ':' > /dev/null 2>&1`; then	# If port has a colon
    :
  else
    port=$port:$host:$port
  fi
  if [ -n "$time" ]; then
    ssh -f -L$port $host sleep $time; echo "Connection will be available for $time seconds...";
  else
    ssh -f -N -L$port $host
  fi
}
sshstop() {
  pid=`ps -efww | grep $1 | egrep -v grep | awk '{print $2}'`
  if [ -n "$pid" ]; then
    kill $pid
  fi
}

alias headphones='sshportforward xbmc.lapseofthought.com 8181 3600 && echo "Use headphones-stop to end it" && firefox http://localhost:8181/'
alias lazylibrarian='sshportforward xbmc.lapseofthought.com 5299 3600 && echo "Use lazylibrarian-stop to end it" && firefox http://localhost:5299/'
alias maraschino='sshportforward xbmc.lapseofthought.com 7000 3600 && echo "Use maraschino-stop to end it" && firefox http://localhost:7000/'
alias pytivo='sshportforward xbmc.lapseofthought.com 9032 3600 && echo "Use pytivo-stop to end it" && firefox http://localhost:9032/'
alias sabnzbd='sshportforward xbmc.lapseofthought.com 8085 3600 && echo "Use sabnzbd-stop to end it" && firefox http://localhost:8085/'
alias sickbeard='sshportforward xbmc.lapseofthought.com 8081 3600 && echo "Use sickbeard-stop to end it" && firefox http://localhost:8081/'
alias subsonic='sshportforward xbmc.lapseofthought.com 4040 3600 && echo "Use subsonic-stop to end it" && firefox http://localhost:4040/'
alias utorrent='sshportforward xbmc.lapseofthought.com 8082 3600 && echo "Use utorrent-stop to end it" && firefox http://localhost:8082/'
alias xbmc='sshportforward xbmc.lapseofthought.com 8080 3600 && echo "Use xbmc-stop to end it" && firefox http://localhost:8080/'
alias headphones-stop='sshstop 8181:xbmc.lapseofthought.com:8181'
alias lazylibrarian-stop='sshstop 5299:xbmc.lapseofthought.com:5299'
alias maraschino-stop='sshstop 7000:xbmc.lapseofthought.com:7000'
alias pytivo-stop='sshstop 9032:xbmc.lapseofthought.com:9032'
alias sabnzbd-stop='sshstop 8085:xbmc.lapseofthought.com:8085'
alias sickbeard-stop='sshstop 8081:xbmc.lapseofthought.com:8081'
alias subsonic-stop='sshstop 4040:xbmc.lapseofthought.com:4040'
alias utorrent-stop='sshstop 8082:xbmc.lapseofthought.com:8082'
alias xbmc-stop='sshstop 8080:xbmc.lapseofthought.com:8080'

#!/bin/bash

# interactively remove file -- good for beginners
alias rm='rm -i'

alias ?='man man'
alias ls='ls -CF --color=always'
alias grep='grep --color=always'
alias egrep='egrep --color=always'
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

alias addpath='set path = (`pwd` $path) ; echo "path now includes `pwd`"'

alias al='ls -al'
alias su='su -'

# logout alias
alias bye='clear; logout'

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

#
# DWA Aliases
alias sys_hey="sys_hey -fg DarkRed -image /home/drich/Images/heybg.jpg -font lucidasans-bold-12 -nogray"
#alias pw_escrow='cat /home/systems/pw_escrow/executive.asc | gpg --decrypt | less'
alias pw_escrow='TMPFILE=`mktemp` && cp /home/systems/pw_escrow/executive.asc $TMPFILE && gpg --decrypt $TMPFILE | less && /bin/rm $TMPFILE'
alias rpmarch='rpm -qa --qf "%{name}-%{version}-%{release}.%{arch}\n"'
alias rpmtime='rpm -qa --qf "%{installtime} (%{installtime:date}) %{name}\n"'

# JIRA aliases
alias ut_ticket='ut_ticket -config /usr/home/dst/config/data/ut_ticket.config'

# DWA VNC
alias lasvncstart="ssh -f -n gw.virtualdreamworks.com vncserver -geometry :42 1280x1024"
alias lasvncstop="ssh -f -n gw.virtualdreamworks.com vncserver -kill :42"
alias lasvncforward="ssh -f -N -L5904:localhost:5942 gw.virtualdreamworks.com"
alias skyglowvncstart="ssh -f -n skyglow x11vnc -display :0 -many -bg  && sleep 5 && vncviewer skyglow"
alias skyglowvncstop="ssh -f -n skyglow killall x11vnc"
alias odw-vnc='ssh -fN -L5999:localhost:5900 odw-vnc && vncviewer :99'

# LDAP aliases/functions
ldappinfo () {
  ldapsearch -LLL -x uid=$1 uid cn ou passwordExpirationTime passwordRetryCount retryCountResetTime accountUnlockTime
}

# Sudo aliases
alias sudo2zenoss='sudo -Hi -u zenoss $*'

# Puppet aliases
function puppetrunroot() {
  PATH=/bin:/usr/bin sudo -iH /usr/local/bin/puppetrun $*;
}
function puppetcronroot() {
  PATH=/bin:/usr/bin sudo -iH /usr/local/bin/puppetcron && grep puppet /var/log/messages $*;
}
function puppetgittest() {
  PATH=/bin:/usr/bin sudo -iH puppet apply --modulepath=/usr/pic1/git/puppet/modules /usr/pic1/git/puppet/site.pp $*;
}
function puppetgittestremote() {
  PATH=/bin:/usr/bin sudo -iH puppet apply --modulepath=/hosts/grayfury/usr/pic1/git/puppet/modules /hosts/grayfury/usr/pic1/git/puppet/site.pp $*;
}
alias puppeterrors='SDATE=`date +"%b %e"` && egrep "${SDATE}.*puppet" /var/log/messages'
alias prr=puppetrunroot
alias pcr=puppetcronroot
alias pgt=puppetgittest
alias pgtr=puppetgittestremote

# DDU proxy for downloads
startdduproxy() {
  if [ -n "$1" ]; then
    ssh -nNTgx -D 4444 aretha.pdi.com &
    ssh -nNTx -R 33128:mpt-internetproxy.anim.dreamworks.com:8080 $1 &
    ssh -nNTx -R 4444:aretha.pdi.com:4444 $1 &
    echo "On $1, run the following:"
    echo "export socks_proxy=socks://`hostname`:4444/"
    echo "export http_proxy=http://localhost:33128/"
    echo ""
    echo "To use socks with python for zenoss, TSOCKS_CONF_FILE=~/tsocks.conf tsocks python setup.py install"
  else
    echo "usage: startdduproxy dduhost" >&2
  fi
}
stopdduproxy() {
  if [ -n "$1" ]; then
    PID1=`ps -efww | egrep -- 'ssh.*-D 4444' | egrep -v grep | awk '{print $2}'`
    PID2=`ps -efww | egrep -- "ssh.*-R 33128.*$1" | egrep -v grep | awk '{print $2}'`
    PID1=`ps -efww | egrep -- 'ssh.*-R 4444' | egrep -v grep | awk '{print $2}'`
    if [ -n "$PID1" -o -n "$PID2" -o -n "$PID3" ]; then
      kill $PID1 $PID2 $PID3
    fi
  else
    echo "usage: stopdduproxy dduhost" >&2
  fi
}

# Default dsh to ssh
export DSH_REMOTE_CMD=ssh
alias dsh='dsh -o "-o StrictHostKeyChecking=no" -t sh'

# OSA aliases
alias hermit='/usr/home/osa/scripts/hermit'

# END DWA
#

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
 sshfqdn=`host $1 | awk '{print $1}'`
  sshaddr=`host $1 | awk '{print $NF}'`
  #sshhost=`nslookup $1 | sed -n '/Name:/,/Address:/p' | awk '{print $2}'`
  for sshhost in $1 $sshfqdn $sshaddr; do
    exists=`ssh-keygen -F $sshhost | wc -c`
    if [ "$exists" != 0 ]; then
      echo $sshhost | sed 's/,/ /g' | xargs -n1 ssh-keygen -R
    fi
  done
  ssh $sshfqdn
}
alias sshnokey='ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no'


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

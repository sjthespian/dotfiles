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
#print() { pr -l66 $* |lp }
#nprint() { pr -n5 -l66  $* | lp; }
#prlong() { fold $* | pr -l66 -h $* | lp; }
#prman() { man $* | lp; }
#frlogin() {
    #/usr/ucb/rlogin $*;echo You are back on `hostname`;
#}
#alias rlogin='frlogin'
#ftelnet() {
    #/usr/ucb/telnet $*;echo You are back on `hostname`;
#}
#alias telnet='ftelnet'
#killall() { if [ -n "$1" && `echo $1 | sed '/^-/p'` = $1 ]; then SIGNAL=$1; shift; else SIGNAL="" fi; echo $SIGNAL `ps -aux | grep $* | awk '{print $2}'` }

# Use the Berkeley Mail program
alias mail='Mail'

alias addpath='set path = (`pwd` $path) ; echo "path now includes `pwd`"'

alias al='ls -al'
#cx() { chmod +x $*; }
#hogs() { cd $HOME; cd ..; du -s * | sort -rn | more; }
alias su='su -'

# unpack tar files
#untar() { zcat $*.tar.Z ; tar xvof -; }

# print files in read protected directories to default printer 
#tlp() { cat $* | /usr/bin/lp; }

# change directories to a file server
#rcd() { cd /r/$*/u/$USER; }

# logout alias
alias bye='clear; logout'

# Mail reader
#alias vm='emacs -i -f vm'
alias emacs19='/usr/appl/emacs-19/bin/mips-sgi-irix5/emacs'
alias vm19='/usr/appl/emacs-19/bin/mips-sgi-irxi5/emacs -f vm'

##fenscript() { /usr/bin/enscript -2rGp - $* | lpr; }
##alias enscript='fenscript'
#fpsroff() { /usr/bin/psroff -t $* | lpr; }
#alias psroff='fpsroff'
#alias xtrn='/usr/sbin/xwsh -name trn -title ReadNews -icontitle ReadNews -fn 8x13 -geometry 80x60 -bg ivory1 -fg black -bold red -e trn'

# Aliases for cassette labels
alias tape_prolog="awk '/^%.PS/,/^%%BeginDoc//^%%EndDoc/,/^%%EndPro/'"
alias tape_trailer="awk '/^%%Trailer/,/^--eof--\$/'"
catapes() {
    (tape_prolog $TAPEPS;cat $*; tape_trailer $TAPEPS);
}
printapes() {
    (catapes $*) | lp;
}

# Sound conversion aliases
#snd2au() { sox -t .ub -r 11025 $*.snd -r 8000 -U $*.au; }
#vox2au() { sox $*.voc -r 8000 -U $*.au; }
#au2aiff() { sox $*.au $*.aiff; }
#iff2au() { sox -t 8SVX $*.iff -r 8000 -U $*.au }
#iff2aiff() { sox -t 8SVX $*.iff $*.aiff }
#aiff2au() { sox $*.aiff -r 8000 -U $*.au; }

# Add applications to the path

#PATH=$PATH:/usr/appl/pbmplus/bin
export PATH

TAPEPS=$HOME/Archive/Postscript/Tapes/audio-tape.ps

# X11 Auth update
#rxauth() { xauth extract - `uname -n`:0 | rsh $* xauth merge - }

alias imgscan='imgscan ricoh'
alias request='/usr/tmp/requests/request'

# Sun calendar manager
#alias xcm='rxauth thumper; rsh thumper "/usr/openwin/bin/cm -Wfsdb -Wt screen12 -Wr $DISPLAY -bg \"light blue\"" < /dev/null'
#alias xcm='rsh thumper "/usr/openwin/bin/cm -Wfsdb -Wt screen12 -Wr $DISPLAY -bg \"light blue\"" < /dev/null'
alias xcm='( $HOME/bin/rxauth -p /usr/openwin/bin fiji; rsh fiji "DISPLAY=$DISPLAY /usr/openwin/bin/cm -bg \"light blue\"" < /dev/null & )'

# FSP aliases:
#FSP_PORT=6678
#FSP_HOST=192.70.34.205
#FSP_DIR=/
#FSP_TRACE=""
#FSP_DELAY=3000
#export FSP_PORT FSP_HOST FSP_DIR FSP_TRACE FSP_DELAY

#fcd() { FSP_DIR=`(ARGV=$*; set noglob; exec fcdcmd $ARGV)`; export FSP_DIR }
#fls() { (ARGV=$*; set noglob; exec flscmd -CF $ARGV) }
#fget() { (ARGV=$*; set noglob; exec fgetcmd $ARGV) }
#fgrab() { (ARGV=$*; set noglob; exec fgrabcmd $ARGV) }
#fcat() { (ARGV=$*; set noglob; exec fcatcmd $ARGV) }
#fmore() { (ARGV=$*; set noglob; exec fcatcmd $ARGV | less ) }
#frm() { (ARGV=$*; set noglob; exec frmcmd $ARGV) }
#frmdir() { (ARGV=$*; set noglob; exec frmdircmd $ARGV) }
#fpro() { (ARGV=$*; set noglob; exec fprocmd $ARGV) }
#fpwd() { echo $FSP_DIR on $FSP_HOST port $FSP_PORT }
#fhost() { fsp_host=$*; . ~/bin/fhost; unset fsp_host }
##fhost() { FSP_DIR=/; FSP_HOST=$1; FSP_PORT=$2; export FSP_DIR FSP_HOST FSP_PORT }

alias synchronize='synchronize -bg gray80'
alias trn='trn -x6ms +m -S -XXD -B -p -M -G -Hcontent-type -Hcontent-transfer-encoding'

alias bz='/usr/demos/bin/bz -logo crow.bzl -pick'
alias bzflag='/usr/demos/IndiZone/bzflag'

alias chkkwong='rsh guest@shibui last | head'
alias mktape='pushd ~; tar cvf /dev/tape News/.new $* && ( cd News/.new; /bin/rm erotica/* erotica/.xvpics/* teen/* teen/.xvpics/*; mt -t /dev/tape unload); popd'

alias xemacs-beta="/usr/local/beta/bin/xemacs" 
alias xemacs-19.14="/usr/local/beta/bin/xemacs-19.14" 
alias xemacs-20.0="/usr/local/beta/bin/xemacs-20.0" 

# PCP aliases for www
alias pmchart="pmsocks pmchart -h 204.94.214.4"

# TimeSheet copy
alias getjobs="rcp guest@woowoo:/usr/spool/pcnfs/pc-sublime/time.tab WWW/Workarea/TimeSheet/job.nums"

# Workarea aliases
alias wa="cd $HOME/WWW/Workarea; export WORKAREA=$HOME/WWW/Workarea" 
alias wa-cgi="cd $HOME/WWW/Workarea/cgi-bin; export WORKAREA=$HOME/WWW/Workarea/cgi-bin" 
alias wa-java="cd $HOME/WWW/Java; export WORKAREA=$HOME/WWW/Java" 
alias wa-freeware="cd $HOME/Src/Freeware; export WORKAREA=$HOME/Src/Freeware; export ROOT=/hosts/babylon.engr/usr/dist/6.2/LATEST/proot; export TOOLROOT=/hosts/babylon.engr/usr/dist/6.2/LATEST/ptoolroot" 

# resize alias
resize() {
    eval `/usr/local/X11R6/bin/resize $*`
}
alias resettty="stty sane intr '^c' kill '^u' erase '^h'; resize"
alias reset48="stty sane rows 48 intr '^c' kill '^u' erase '^h'; resize"
alias set48="stty rows 48; resize"

#alias pfind='rsh ghostbuster pfind'

alias aim="( /usr/local/aim/aim > /dev/null 2>&1 & )"

# Meeting Maker on my machine at work
alias mmxp="ssh sandman.cisco.com /usr/local/share/bin/mmxp"

# Xterm aliases
settitle () {
  echo -n -e "\033]2;$*\007"
}
seticonname () {
  echo -n -e "\033]1;$*\007"
}

alias wake_dream="sudo ether-wake 00:60:08:20:CF:34"

alias open=gnome-open

# SSH forwarding
endforward() {
  pids=`ps -efww| egrep 'ssh.*morpheus-forward' | egrep -v grep | awk '{print $2}'`
  if [ -n "$pids" ]; then
    kill $pids
  fi
}
alias homeforward='endforward && ssh -f -N morpheus-forward && echo "Proxy started"'
alias homeproxyforward='endforward && ssh -f -N morpheus-forward-proxy && echo "Proxy started"'

# Larger window for rdesktop
alias rdesktop='rdesktop -g1152x768'

# VNC is vinagre
alias vncviewer="vinagre"

fixssh() {
  sshhost=`nslookup $1 | sed -n '/Name:/,/Address:/p' | awk '{print $2}'`
  for sshhost in $1 $sshhost; do
    exists=`ssh-keygen -F $sshhost | wc -c`
    if [ "$exists" != 0 ]; then
      echo $sshhost | sed 's/,/ /g' | xargs -n1 ssh-keygen -R
    fi
  done
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

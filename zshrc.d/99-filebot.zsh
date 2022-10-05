# Convenient aliases for filebot
#
# Make sure this is only loaded once
#if [ -n "${LOADED_99_FILEBOT}" ]; then
#  return
#else
#  LOADED_99_FILEBOT=1
#fi

# Set video base dir some systems use /srv
VBASE=/media
if [ -d /srv/media ]; then
  VBASE=/srv/media
fi

call_filebot() {
    # Usage call_filebot movie [TEST] file [...]
    #       call_filebot music [TEST] [multidisc] [various|soundtrack|showtunes|virtual artist] file [...]
    #       call_filebot tvshow|anime [TEST] DVD|DOWNLOAD [RES]
    #           Optional "res" will include video resolution in the filename 
    type=$1
    shift
    dryrun=""
    if [ "$1" = "TEST" ]; then
        dryrun=1
        shift
    fi
    case $type in
        movie)
            args="-rename -non-strict --db TheMovieDB"
            format='{plex.derive{" $audioLanguages"}{" [$resolution]"}}'
            output=${VBASE}/video/DVDs/
            ;;
        music)
            args='-rename -non-strict --db ID3'
	    multidisc=
	    format='{artist}/{album+'\''/'\''}{pi.pad(2)} {t}'
	    if [ $1 = "multidisc" ]; then
		multidisc=1
		shift
            fi
	    case $1 in
	        virtual)
		    shift
		    artist=$1
		    shift
	            format='['${artist}']/{album+'\''/'\''}{pi.pad(2)} {t}'
		    ;;
	        various)
		    shift
	            format='Various Artists/{album+'\''/'\''}{pi.pad(2)} {t} ({artist})'
		    ;;
	        showtunes)
		    shift
	            format='Showtunes/{album+'\''/'\''}{pi.pad(2)} {t} ({artist})'
		    ;;
	        soundtrack)
		    shift
	            format='Soundtracks/{album+'\''/'\''}{pi.pad(2)} {t} ({artist})'
		    ;;
	    esac
	    # Change track number in format for multidisc
	    if [ -n "$multidisc" ]; then
	        format="$(echo $format | sed 's/{pi.pad(2)/{media.Part}{media.PartPosition}-{pi.pad(2)/')"
	    fi
            output=${VBASE}/mp3/
            ;;
        tvshow|anime)
            format='{plex.tail}'
            case $1 in
                DVD)
                    output="${VBASE}/video/DVDs/TV_Shows/"
                    shift
                    ;;   
                DOWNLOAD)
                    output="${VBASE}/video/TV/"
                    shift
                    ;;   
                *)
                    echo "ERROR: unknown TV type, must be DVD or DOWNLOAD!"
                    exit 1
                    ;;
            esac
            if [ "$1" = "RES" ]; then
                format='{plex.derive{" [$resolution]"}.tail}'
                if [ $type = "anime" ]; then
                    format='{localize.English.plex.derive{" [$resolution]"}.tail}'
                fi
                shift
            fi
            args="-rename -non-strict --db TheTVDB"
            if [ $type = "anime" ]; then
                #format='{localize.English.plex.tail}'
                format='{localize.English.n}/{localize.English.n} - {absolute.pad(episodelist.size() < 99 ? 2 : 3)} - {localize.English.t}'
                args="-rename -non-strict --db AniDB --lang English"
            fi
            ;;
        *)
            echo 'Unknown file type "$type"!'
            exit 1
            ;;
    esac
    if [ -n "$dryrun" ]; then
        args="$args --action TEST"
    fi
    set -x
    filebot $=args --format $format --output $output $*
    set +x
}

# Movie aliases
alias fbmovie='call_filebot movie'
alias fbmovietest='call_filebot movie TEST'
# Music alises
alias fbmusic='call_filebot music'
alias fbmusictest='call_filebot music TEST'
alias fbmusicmd='call_filebot music multidisc'
alias fbmusicmdtest='call_filebot music TEST multidisc'
alias fbmusicvdis='call_filebot music virtual disney'
alias fbmusicvdistest='call_filebot music TEST virtual disney'
alias fbmusicmdvdis='call_filebot music multidisc virtual disney'
alias fbmusicmdvdistest='call_filebot music TEST multidisc virtual disney'
alias fbmusicvar='call_filebot music various'
alias fbmusicvartest='call_filebot music TEST various'
alias fbmusicmdvar='call_filebot music multidisc various'
alias fbmusicmdvartest='call_filebot music TEST multidisc various'
alias fbmusicsh='call_filebot music showtunes'
alias fbmusicshtest='call_filebot music TEST showtunes'
alias fbmusicmdsh='call_filebot music multidisc showtunes'
alias fbmusicmdshtest='call_filebot music TEST multidisc showtunes'
alias fbmusicst='call_filebot music soundtrack'
alias fbmusicsttest='call_filebot music TEST soundtrack'
alias fbmusicmdst='call_filebot music multidisc soundtrack'
alias fbmusicmdsttest='call_filebot music TEST multidisc soundtrack'
# TV show aliass
alias fbdvdtv='call_filebot tvshow DVD'
alias fbdvdtvtest='call_filebot tvshow TEST DVD'
alias fbdvdtvres='call_filebot tvshow DVD RES'
alias fbdvdtvrestest='call_filebot tvshow TEST DVD RES'
alias fbdltv='call_filebot tvshow DOWNLOAD'
alias fbdltvtest='call_filebot tvshow TEST DOWNLOAD'
alias fbdltvres='call_filebot tvshow DOWNLOAD RES'
alias fbdltvrestest='call_filebot tvshow TEST DOWNLOAD RES'
# Anime aliases
alias fbdvdanime='call_filebot anime DVD'
alias fbdvdanimetest='call_filebot anime TEST DVD'
alias fbdvdanimeres='call_filebot anime DVD RES'
alias fbdvdanimerestest='call_filebot anime TEST DVD RES'
alias fbdlanime='call_filebot anime DOWNLOAD'
alias fbdlanimetest='call_filebot anime TEST DOWNLOAD'
alias fbdlanimeres='call_filebot anime DOWNLOAD RES'
alias fbdlanimerestest='call_filebot anime TEST DOWNLOAD RES'

# Fix plex ownership and permissions
plexperms () {
  dir=${1:-.}
  sudo chown -R plex:plex $dir
  sudo chmod -R g+rw,a+r $dir
}
mp3perms () {
  for d in $*; do
    dir=${d:-.}
    sudo chgrp -R mp3 $dir
    sudo chmod -R g+rw,a+r $dir
    find $dir -type d -print0 | xargs -0 sudo chmod g+s
  done
}

# Youtube DL alias for filebot
ytdltv() {
  usage() {
    if [ -n "$1" ]; then
      echo $1
    fi
    echo "usage: ytdltv [show_name] S##E## url"
    return 1
  }
  show="."
  if [ "$#" -gt 2 ]; then	# If no first arg, use pwd as show name
    show=$1
    shift
  fi
  se=$1
  url=$2
  ret=
  if [ -z "$show" -o -z "$se" -o -z "$url" ]; then
    usage
    ret=$(( $? > 0 ))
  fi
  if [ "$show" = "." ]; then
    show="$(pwd | sed 's/^.*\///')"
  fi
  if [[ $se =~ 'S[0-9]*E[0-9]*' ]]; then
    :
  else 
    usage "ERROR $se does not match S##E##"
    ret=$(( $? > 0 ))
  fi
  if [ -z "$ret" -o "$ret" = 0 ]; then
    #echo youtube-dl -o "\"$show - $se %(title)s.%(ext)s\"" $url
    #youtube-dl -o "$show - $se %(title)s.%(ext)s" $url
    echo yt-dlp -o "\"$show - $se %(title)s.%(ext)s\"" $url
    yt-dlp -o "$show - $se %(title)s.%(ext)s" $url
  fi
  call_filebot tvshow DOWNLOAD *"$se"*
}

# Remove [xxx] from youtube downloads
ytrename() {
  for f in *\[*\].*; do
    n=$(echo $f | sed 's/[[:space:]]*\[[^]]*\]\././')
    mv "$f" "$n"
  done
}

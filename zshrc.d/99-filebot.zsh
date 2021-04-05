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
    #       call_filebot music [TEST] file [...]
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
            args='-rename -non-strict --db TheMovieDB'
            format='{plex.derive{" $audioLanguages"}{" [$resolution]"}}'
            output=${VBASE}/video/DVDs/
            ;;
        music)
            args='-rename -non-strict --db ID3'
            format='{plex.tail}'
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

# Youtube DL alias for filebot
ytdltv() {
  usage() {
    if [ -n "$1" ]; then
      echo $1
    fi
    echo "usage: ytdltv show_name S##E## url"
    return 1
  }
  show=$1
  se=$2
  url=$3
  ret=
  if [ -z "$show" -o -z "$se" -o -z "$url" ]; then
    usage
    ret=$(( $? > 0 ))
  fi
  if [[ $se =~ 'S[0-9]*E[0-9]*' ]]; then
    :
  else 
    usage "ERROR $se does not match S##E##"
    ret=$(( $? > 0 ))
  fi
  if [ -z "$ret" -o "$ret" = 0 ]; then
    youtube-dl -o "$show - $se %(title)s.%(ext)s" $url
  fi
}

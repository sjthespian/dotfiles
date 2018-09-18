#
# prepend() and append() functions for path management
#
addtopath() { 
    eval value=\"\$$1\"
    case $3 in
	p*) result="$2:${value}" ;;
	*) case "$value" in
	    *:$2:*|*:$2|$2:*|$2) result="$value" ;;
	    "") result="$2" ;;
            *) result="${value}:$2"  ;;
	esac;;
    esac
    # Strip duplicate entries, '//', and '::' (and leading or trailing ':')
    result=`echo $result | awk -F: '{for (i=1; i<=NF; i++) {if (length($i) == 0) continue; if (a[$i] == 0) printf "%s:",$i; a[$i]++}}' | sed 's/:$//'`
    
    eval $1=$result
    unset result value
}

append() {
    addtopath $1 $2 append
}
prepend() {
    addtopath $1 $2 prepend
}

# Function to load additional bashrc files
_load_bashrc_d() {
    [ -d ~/.bashrc.d ] || return

    for script in ~/.bashrc.d/*.sh; do
#        . $script >/dev/null 2>&1 || echo "WARNING: include of $script failed!" 1>&2
        . $script || echo "WARNING: include of $script failed!" 1>&2
    done
}


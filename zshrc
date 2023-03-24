# Read zsh aliases and functions
[[ -f ~/.zsh_functions ]] && . ~/.zsh_functions
[[ -f ~/.zsh_aliases ]] && . ~/.zsh_aliases

# Add user bin and /usr/local to beginning of path
prepend PATH /usr/local/sbin:/usr/local/bin
prepend PATH ~/.local/bin
prepend PATH $HOME/bin
export PATH

# Done unless this is an interactive shell
INTERACTIVE=
if [[ -o login || -o interactive ]]; then
  INTERACTIVE=1
fi
[ -z "$INTERACTIVE" ] && return

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- or random
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"
# PowerLevel10K setup - https://github.com/romkatv/powerlevel10k
if [ -e $ZSH_CUSTOM/themes/powerlevel10k ]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
  POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
fi

# Set list of themes to pick from when loading at random
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Set '-CC' option for iTerm2 tmux integration
ZSH_TMUX_ITERM2=true

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(battery emacs gcloud git github gpg-agent iterm2 rsync sudo tmux zsh-autosuggestions)
# Only install plugins if the software exists
if (( $+commands[ansible] )); then
  plugins+=(ansible)
fi
if (( $+commands[brew] )); then
  plugins+=(brew)
fi
if (( $+commands[docker] )); then
  plugins+=(docker docker-compose)
fi
# Use official auto-completion for vault
# This only needs to be run once, it adds the two lines at the end
#if (( $+commands[vault] )); then
#  vault -autocomplete-install
#fi
if (( $+commands[knife] )); then
  plugins+=(knife kitchen)
fi
if (( $+commands[kubectl] )); then
  plugins+=(kubectl helm)
fi
if (( $+commands[microk8s] )); then
  plugins+=(microk8s)
  alias kubectl="microk8s.kubectl"
fi
if (( $+commands[aws] )); then
  plugins+=(aws)
fi
if (( $+commands[terraform] )); then
  plugins+=(terraform)
fi
if grep 'ID=ubuntu' /etc/os-release > /dev/null 2>&1; then
  plugins+=(systemd ubuntu)
fi

# User configuration

# Bash-like navigation
autoload -U select-word-style
select-word-style bash

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Load additional bash init files
_load_zshrc_d

# If set and it exists, add system type specific path
[[ -n "$CONFIG_GUESS" && -d "$HOME/bin/$CONFIG_GUESS" ]] && prepend PATH $HOME/bin/$CONFIG_GUESS

export PATH

# NOTE: zsh-syntax-hilighting must be the last plugin
plugins+=(zsh-syntax-highlighting)
. $ZSH/oh-my-zsh.sh

if (( $+commands[vault] )); then
  # Added by vault -autocomplete-install
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /usr/local/bin/vault vault
fi

# Use HomeBrew ruby if available
if [[ -f /usr/local/opt/ruby/bin/ruby ]]; then
  prepend PATH /usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/3.0.0/bin
fi

# Enable history per window
unsetopt inc_append_history
unsetopt share_history

# Fix annoying omyzsh binding
bindkey '\el' down-case-word

# Read zsh aliases and functions
[[ -f ~/.zsh_functions ]] && . ~/.zsh_functions
[[ -f ~/.zsh_aliases ]] && . ~/.zsh_aliases

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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(battery git github gpg-agent rsync sudo zsh-autosuggestions)
# Only install plugins if the software exists
if hash ansible 2>/dev/null; then
  plugins+=(ansible)
fi
if hash brew 2>/dev/null; then
  plugins+=(brew)
fi
if hash docker 2>/dev/null; then
  plugins+=(docker docker-compose)
fi
if hash emacs 2>/dev/null; then
  plugins+=(emacs)
fi
if hash tmux 2>/dev/null; then
  plugins+=(tmux)
fi
if hash vault 2>/dev/null; then
  plugins+=(vault)
fi
if hash chef 2>/dev/null; then
  plugins+=(knife kitchen)
fi
if hash kubectl 2>/dev/null; then
  plugins+=(kubectl helm)
fi
if hash aws 2>/dev/null; then
  plugins+=(aws)
fi
if hash gcloud 2>/dev/null; then
  plugins+=(gcloud)
fi
if hash terraform 2>/dev/null; then
  plugins+=(terraform)
fi
if hash systemctl 2>/dev/null; then
  plugins+=(systemd ubuntu)
fi

# User configuration

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

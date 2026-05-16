# Set XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}

# Relocate zsh config
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

# Homebrew (static, Apple Silicon)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brewfile/Brewfile"
export HOMEBREW_NO_ANALYTICS=1

# Set the list of directories that zsh searches for commands.
path=(
  $HOME/.local/{,s}bin(N)
  $HOME/.cargo/bin
  $HOMEBREW_PREFIX/{,s}bin(N)
  /usr/local/{,s}bin(N)
  /usr/local/go/bin
  $HOME/go/bin
  $path
)

path=($^path(N-/))
manpath=($HOMEBREW_PREFIX/share/man $manpath)
infopath=($HOMEBREW_PREFIX/share/info $infopath)

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath manpath infopath

# Fish-like dirs
: ${__zsh_config_dir:=${ZDOTDIR}}
: ${__zsh_user_data_dir:=${XDG_DATA_HOME}/zsh}
: ${__zsh_cache_dir:=${XDG_CACHE_HOME}/zsh}

# Ensure Zsh directories exist.
() {
  local zdir
  for zdir in $@; do
    [[ -d "${(P)zdir}" ]] || mkdir -p -- "${(P)zdir}"
  done
} __zsh_{config,user_data,cache}_dir XDG_{CONFIG,CACHE,DATA,STATE}_HOME

# Antidote
export ANTIDOTE_HOME=${ANTIDOTE_HOME:-$XDG_DATA_HOME/antidote}

# Locale settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Use Neovim as default editor
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -FX"

# Go
export GOPATH=$HOME/go

# Theme: catppuccin-mocha | dracula | nord | rose-pine | tokyo-night | gruvbox-dark | everforest | kanagawa
export THEME="catppuccin-mocha"

# Evalcache
export ZSH_EVALCACHE_DIR="$XDG_CACHE_HOME/zsh/.zsh-evalcache"

# Set XDG
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-$HOME/.xdg}
export XDG_PROJECTS_DIR=${XDG_PROJECTS_DIR:-$HOME/projects}

# And relocate zsh config
export ZDOTDIR=${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

# Set the list of directories that zsh searches for commands.
path=(
  $path
  $HOME/{,s}bin(N)
  $HOME/.local/{,s}bin(N)
  $HOME/.cargo/bin
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
)

path=($^path(N-/))

# Ensure path arrays do not contain duplicates.
typeset -gU path fpath

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
} __zsh_{config,user_data,cache}_dir XDG_{CONFIG,CACHE,DATA,STATE}_HOME XDG_{RUNTIME,PROJECTS}_DIR

# Antidote
export ANTIDOTE_HOME=${ANTIDOTE_HOME:-$XDG_DATA_HOME/antidote}

# Locale settings
export LANG="en_US.UTF-8" # Sets default locale for all categories
export LC_ALL="en_US.UTF-8" # Overrides all other locale settings
export LC_CTYPE="en_US.UTF-8" # Controls character classification and case conversion

# Use Neovim as default editor
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -FX"

export GPG_TTY=$(tty) # Set Git GPG tty
export MANPATH="/usr/local/man:$MANPATH" # Set manpath
export NVM_DIR="$HOME/.nvm" # Set NVM Home directory
export PATH="$HOME/.poetry/bin:$PATH" # Set Poetry Home directory
export PATH="$HOME/.local/bin:$PATH" # Set local bin directory
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brewfile/Brewfile" # brewfile path
export ZSH_EVALCACHE_DIR="$XDG_CACHE_HOME/zsh/.zsh-evalcache"


# Load styles
[[ ! -f ${ZDOTDIR}/.zstyles ]] || source ${ZDOTDIR}/.zstyles

# Load aliases
[ ! -f ${ZDOTDIR}/.zalias ] || source ${ZDOTDIR}/.zalias

# Clone antidote if missing.
[[ -d $ANTIDOTE_HOME ]] || git clone --depth 1 --quiet https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME

# Lazy-load antidote from its functions directory.
fpath=($ANTIDOTE_HOME/functions $fpath)
autoload -Uz antidote

# Generate static file in a subshell whenever .zplugins is updated.
zplugins=${ZDOTDIR}/.zplugins
if [[ ! ${zplugins}.zsh -nt ${zplugins} ]] || [[ ! -e $ANTIDOTE_HOME/.lastupdated ]]; then
  antidote bundle <${zplugins} >|${zplugins}.zsh
  date +%Y-%m-%dT%H:%M:%S%z >| $ANTIDOTE_HOME/.lastupdated
fi

# Source the static file.
source ${zplugins}.zsh

# Load shell completions

source <(starship init zsh)
source <(fzf --zsh)
source <(zoxide init --cmd=cd zsh)
source <(uv generate-shell-completion zsh)
source <(uvx --generate-shell-completion zsh)

# Load customizations
[ ! -f ${ZDOTDIR}/.zcustom ] || source ${ZDOTDIR}/.zcustom

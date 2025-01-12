# Load styles
[[ ! -f ${ZDOTDIR}/.zstyles ]] || source ${ZDOTDIR}/.zstyles

# Load aliases
[ ! -f ${ZDOTDIR}/.zalias ] || source ${ZDOTDIR}/.zalias

# Load shell completions

source <(starship init zsh)
source <(fzf --zsh)
source <(zoxide init --cmd=cd zsh)
source <(uv generate-shell-completion zsh)
source <(uvx --generate-shell-completion zsh)

# Load customizations
[ ! -f ${ZDOTDIR}/.zcustom ] || source ${ZDOTDIR}/.zcustom

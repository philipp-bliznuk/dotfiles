# Load styles
[[ ! -f ${ZDOTDIR}/.zstyles ]] || source ${ZDOTDIR}/.zstyles

# Load aliases
[ ! -f ${ZDOTDIR}/.zalias ] || source ${ZDOTDIR}/.zalias

# Load shell completions

_evalcache starship init zsh
_evalcache fzf --zsh
_evalcache zoxide init --cmd=cd zsh
_evalcache uv generate-shell-completion zsh
_evalcache uvx --generate-shell-completion zsh

# Load customizations
[ ! -f ${ZDOTDIR}/.zcustom ] || source ${ZDOTDIR}/.zcustom

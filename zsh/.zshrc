# One tmux session for every terminal; the outer shell is replaced, so nothing
# below runs twice. NO_TMUX=1 opts out.
if [[ -z $TMUX && -z $NO_TMUX && -t 0 && -t 1 ]] && (( ${+commands[tmux]} )); then
  exec tmux new-session -A -s default
fi

# GPG tty (zsh builtin, no fork)
export GPG_TTY=$TTY
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# History
HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
HISTSIZE=60000 # above SAVEHIST, hist_expire_dups_first needs the headroom
SAVEHIST=50000
setopt share_history hist_ignore_dups hist_ignore_space hist_verify
setopt hist_expire_dups_first hist_find_no_dups extended_history

# Homebrew completions
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)

# Load styles (must be before plugins for antidote/fzf-tab zstyles)
[[ -f ${ZDOTDIR}/.zstyles ]] && source ${ZDOTDIR}/.zstyles

# zsh-vi-mode config (must be set before plugin loads)
function zvm_config() {
  ZVM_KEYTIMEOUT=0.2
}

# Clone antidote if missing.
[[ -d $ANTIDOTE_HOME ]] || git clone --depth 1 --quiet https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME

# Generate static file whenever .zplugins is updated. Moved into place only
# when every bundle cloned (antidote bundle exits 1 otherwise): a partial file
# would be newer than .zplugins and never regenerated.
zplugins=${ZDOTDIR}/.zplugins
if [[ ! ${zplugins}.zsh -nt ${zplugins} ]] || [[ ! -e $ANTIDOTE_HOME/.lastupdated ]]; then
  fpath=($ANTIDOTE_HOME/functions $fpath)
  autoload -Uz antidote
  if antidote bundle <${zplugins} >|${zplugins}.zsh.new; then
    mv -f ${zplugins}.zsh.new ${zplugins}.zsh
    date +%Y-%m-%dT%H:%M:%S%z >| $ANTIDOTE_HOME/.lastupdated
  else
    rm -f ${zplugins}.zsh.new
  fi
fi

# Source the static file (absent until the first bundle run succeeds).
[[ -f ${zplugins}.zsh ]] && source ${zplugins}.zsh

# Load aliases
[[ -f ${ZDOTDIR}/.zalias ]] && source ${ZDOTDIR}/.zalias

# FZF colors (catppuccin-mocha)
export FZF_DEFAULT_OPTS="\
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --color=border:#6c7086,label:#cdd6f4"

# F-Sy-H theme: applied once, the plugin remembers it. Deferred because the
# plugin itself loads deferred.
zsh-defer -c '[[ $FAST_THEME_NAME == catppuccin-mocha ]] || fast-theme "$ZDOTDIR/catppuccin-mocha.ini" >/dev/null'

# Prompt (pure zsh, no external deps)
[[ -f ${ZDOTDIR}/.zprompt ]] && source ${ZDOTDIR}/.zprompt

# Shell integrations (eager: keybinds, cd) and completions, cached by
# evalcache. Completions load after the first prompt (zsh-defer comes with
# the plugins).
_evalcache fzf --zsh
_evalcache zoxide init --cmd=cd zsh
zsh-defer _evalcache uv generate-shell-completion zsh
zsh-defer _evalcache uvx --generate-shell-completion zsh
zsh-defer _evalcache jj util completion zsh
zsh-defer _evalcache podman completion zsh

# Load customizations
[[ -f ${ZDOTDIR}/.zcustom ]] && source ${ZDOTDIR}/.zcustom

# GPG tty (zsh builtin, no fork)
export GPG_TTY=$TTY

# History
HISTFILE="$XDG_DATA_HOME/zsh/zsh_history"
HISTSIZE=50000
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
  ZVM_ESCAPE_KEYTIMEOUT=0.03
}

# Clone antidote if missing.
[[ -d $ANTIDOTE_HOME ]] || git clone --depth 1 --quiet https://github.com/mattmc3/antidote.git $ANTIDOTE_HOME

# Generate static file whenever .zplugins is updated.
zplugins=${ZDOTDIR}/.zplugins
if [[ ! ${zplugins}.zsh -nt ${zplugins} ]] || [[ ! -e $ANTIDOTE_HOME/.lastupdated ]]; then
  fpath=($ANTIDOTE_HOME/functions $fpath)
  autoload -Uz antidote
  antidote bundle <${zplugins} >|${zplugins}.zsh
  date +%Y-%m-%dT%H:%M:%S%z >| $ANTIDOTE_HOME/.lastupdated
fi

# Source the static file.
source ${zplugins}.zsh

# Load aliases
[[ -f ${ZDOTDIR}/.zalias ]] && source ${ZDOTDIR}/.zalias

# Theme: load palette and apply colors
source "$XDG_CONFIG_HOME/themes/$THEME/theme.zsh"

# FZF colors from THEME_COLORS
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --color=bg+:${THEME_COLORS[surface0]},bg:${THEME_COLORS[base]},spinner:${THEME_COLORS[rosewater]},hl:${THEME_COLORS[red]} \
  --color=fg:${THEME_COLORS[text]},header:${THEME_COLORS[red]},info:${THEME_COLORS[mauve]},pointer:${THEME_COLORS[rosewater]} \
  --color=marker:${THEME_COLORS[lavender]},fg+:${THEME_COLORS[text]},prompt:${THEME_COLORS[mauve]},hl+:${THEME_COLORS[red]} \
  --color=selected-bg:${THEME_COLORS[surface1]} \
  --color=border:${THEME_COLORS[overlay0]},label:${THEME_COLORS[text]}"

# F-Sy-H theme (only re-apply if theme changed)
(( ${+FAST_THEME_NAME} )) && [[ "$FAST_THEME_NAME" != "$THEME" ]] && \
  fast-theme "$XDG_CONFIG_HOME/themes/$THEME/theme.ini" 2>/dev/null

# Shell completions (cached via evalcache) — eager: affects prompt/keybinds/cd
_evalcache starship init zsh
_evalcache fzf --zsh
_evalcache zoxide init --cmd=cd zsh

# Deferred completions — load on first keypress via zle-line-init hook
function _deferred_completions() {
  _evalcache uv generate-shell-completion zsh
  _evalcache uvx --generate-shell-completion zsh
  _evalcache jj util completion zsh
  _evalcache podman completion zsh
  unfunction _deferred_completions _deferred_completions_hook
  add-zle-hook-widget -d zle-line-init _deferred_completions_hook
}
function _deferred_completions_hook() { _deferred_completions; }
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-init _deferred_completions_hook

# Load customizations
[[ -f ${ZDOTDIR}/.zcustom ]] && source ${ZDOTDIR}/.zcustom

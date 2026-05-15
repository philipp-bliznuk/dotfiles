fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mroth-SLASH-evalcache )
source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mroth-SLASH-evalcache/evalcache.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-ez-compinit )
source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-ez-compinit/ez-compinit.plugin.zsh
if ! (( $+functions[zsh-defer] )); then
  fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-romkatv-SLASH-zsh-defer )
  source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-romkatv-SLASH-zsh-defer/zsh-defer.plugin.zsh
fi
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-completions/src )
zsh-defer source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-completions/src/src.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-aloxaf-SLASH-fzf-tab )
zsh-defer source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-aloxaf-SLASH-fzf-tab/fzf-tab.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-syntax-highlighting )
zsh-defer source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions )
zsh-defer source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-history-substring-search )
zsh-defer source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-history-substring-search/zsh-history-substring-search.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-jeffreytse-SLASH-zsh-vi-mode )
source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-jeffreytse-SLASH-zsh-vi-mode/zsh-vi-mode.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/homebrew )
zsh-defer source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/homebrew/homebrew.plugin.zsh
fpath+=( $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/history )
source $HOME/.local/share/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/history/history.plugin.zsh

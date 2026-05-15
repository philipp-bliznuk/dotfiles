#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Formatting
reset_color=$(tput sgr 0)

info() {
	printf "%s[*] %s%s\n" "$(tput setaf 4)" "$1" "$reset_color"
}

success() {
	printf "%s[+] %s%s\n" "$(tput setaf 2)" "$1" "$reset_color"
}

err() {
	printf "%s[!] %s%s\n" "$(tput setaf 1)" "$1" "$reset_color"
}

link() {
	local src="$1"
	local dest="$2"

	if [[ ! -e "$src" && ! -d "$src" ]]; then
		err "Source does not exist: $src"
		return 1
	fi

	rm -rf "$dest"
	mkdir -p "$(dirname "$dest")"
	ln -sf "$src" "$dest"
	info "$dest -> $src"
}

echo ""
info "Symlinking dotfiles..."
echo ""

# Misc files (custom destinations outside $XDG_CONFIG_HOME/<dir>/)
link "$DOTFILES/.zshenv" "$HOME/.zshenv"
link "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/starship/starship.toml" "$XDG_CONFIG_HOME/starship.toml"

# Package dirs -> $XDG_CONFIG_HOME/<name>/
packages=(
	alacritty
	brewfile
	ghostty
	git
	kitty
	nvim
	ruff
	sketchybar
	tmux
	yazi
	zsh
)

for dir in "${packages[@]}"; do
	link "$DOTFILES/$dir" "$XDG_CONFIG_HOME/$dir"
done

echo ""
success "Dotfiles symlinked."

echo ""
info "Installing Homebrew packages..."
zsh -c 'source "$HOME/.zshenv" && brew bundle'
success "Homebrew packages installed."

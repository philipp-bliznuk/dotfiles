#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Available themes: catppuccin-mocha, dracula, nord, rose-pine, tokyo-night, gruvbox-dark, everforest, kanagawa
THEME="catppuccin-mocha"

# Yazi flavor name mapping (yazi-rs/flavors uses different names for some themes)
get_yazi_flavor() {
	case "$1" in
	everforest) echo "everforest-medium" ;;
	*) echo "$1" ;;
	esac
}

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
	bat
	brewfile
	ghostty
	git
	kitty
	nvim
	ruff
	sketchybar
	themes
	tmux
	yazi
	zsh
)

for dir in "${packages[@]}"; do
	link "$DOTFILES/$dir" "$XDG_CONFIG_HOME/$dir"
done

echo ""
success "Dotfiles symlinked."

# Apply theme to config files via sed
echo ""
info "Applying theme: $THEME..."

# .zshenv: update THEME export
sed -i '' "s/^export THEME=\".*\"/export THEME=\"$THEME\"/" "$DOTFILES/.zshenv"

# yazi/theme.toml: update flavor
YAZI_FLAVOR="$(get_yazi_flavor "$THEME")"
sed -i '' "s/^dark = \".*\"/dark = \"$YAZI_FLAVOR\"/" "$DOTFILES/yazi/theme.toml"

success "Theme applied: $THEME"

# Homebrew (must run before tool-specific steps — fresh machine may lack bat/yazi)
echo ""
info "Installing Homebrew packages..."
zsh -c 'source "$HOME/.zshenv" && brew bundle'
success "Homebrew packages installed."

# Build bat theme cache (picks up custom .tmTheme symlinks)
echo ""
info "Building bat theme cache..."
bat cache --build
success "bat cache built."

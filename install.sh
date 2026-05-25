#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# Available themes: catppuccin-mocha, dracula, nord, rose-pine, tokyo-night, gruvbox-dark, everforest, kanagawa
THEME="catppuccin-mocha"

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
mkdir -p "$XDG_CONFIG_HOME/jj"
link "$DOTFILES/jj/config.toml" "$XDG_CONFIG_HOME/jj/config.toml"

# Containers (individual files — dir has podman machine state we must preserve)
mkdir -p "$XDG_CONFIG_HOME/containers"
link "$DOTFILES/containers/containers.conf" "$XDG_CONFIG_HOME/containers/containers.conf"
link "$DOTFILES/containers/registries.conf" "$XDG_CONFIG_HOME/containers/registries.conf"

# Package dirs -> $XDG_CONFIG_HOME/<name>/
packages=(
	alacritty
	bat
	brewfile
	fastfetch
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

# Symlink theme-switch into PATH
link "$DOTFILES/themes/theme-switch" "$HOME/.local/bin/theme-switch"
info "theme-switch -> $HOME/.local/bin/theme-switch"

# Homebrew (must run before tool-specific steps — fresh machine may lack bat/yazi)
echo ""
info "Installing Homebrew packages..."
zsh -c 'source "$HOME/.zshenv" && brew bundle'
success "Homebrew packages installed."

# macOS: auto-hide native menu bar (sketchybar replaces it)
echo ""
info "Configuring macOS settings..."
defaults write .GlobalPreferences _HIHideMenuBar -bool true
defaults write .GlobalPreferences AppleMenuBarVisibleInFullscreen -bool false
success "Menu bar set to auto-hide (takes effect after logout/reboot)."

# Apply theme (sed, symlinks, bat cache — no reload, handled below)
echo ""
info "Applying theme: $THEME..."
"$DOTFILES/themes/theme-switch" --no-reload "$THEME"

# Reload: kill tmux + restart sketchybar to pick up all changes
echo ""
read -rp "Kill tmux server to apply changes? [Y/n] " answer
if [[ "${answer:-Y}" =~ ^[Yy]$ ]]; then
	brew services restart sketchybar 2>/dev/null || true
	tmux kill-server 2>/dev/null || true
fi

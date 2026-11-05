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
	local src="$1" dest="$2"
	[[ -e "$src" ]] || {
		err "missing: $src"
		return 1
	}
	if [[ -e "$dest" && ! -L "$dest" ]]; then
		err "not a symlink, move it away first: $dest"
		return 1
	fi
	rm -f "$dest"
	mkdir -p "$(dirname "$dest")"
	ln -sf "$src" "$dest"
	info "$dest -> $src"
}

echo ""
info "Symlinking dotfiles..."
echo ""

# Misc files (custom destinations outside $XDG_CONFIG_HOME/<dir>/)
link "$DOTFILES/.zshenv" "$HOME/.zshenv"
link "$DOTFILES/qutebrowser" "$HOME/.qutebrowser"
link "$DOTFILES/jj/config.toml" "$XDG_CONFIG_HOME/jj/config.toml"

# Containers (individual files - dir has podman machine state we must preserve)
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
	tmux
	yazi
	zed
	zsh
)

for dir in "${packages[@]}"; do
	link "$DOTFILES/$dir" "$XDG_CONFIG_HOME/$dir"
done

echo ""
success "Dotfiles symlinked."

# Helper scripts -> ~/.local/bin (jj-identity: jj clone/init aliases)
for script in "$DOTFILES"/bin/*; do
	link "$script" "$HOME/.local/bin/$(basename "$script")"
done

# Homebrew
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

# Reload: kill tmux + restart sketchybar to pick up all changes
echo ""
read -rp "Kill tmux server to apply changes? [Y/n] " answer
if [[ "${answer:-Y}" =~ ^[Yy]$ ]]; then
	brew services restart sketchybar 2>/dev/null || true
	tmux kill-server 2>/dev/null || true
fi

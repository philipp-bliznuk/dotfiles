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

# Ghostty theme name mapping (ghostty uses Title Case names)
get_ghostty_theme() {
	case "$1" in
	catppuccin-mocha) echo "Catppuccin Mocha" ;;
	dracula) echo "Dracula" ;;
	nord) echo "Nord" ;;
	rose-pine) echo "Rose Pine" ;;
	tokyo-night) echo "TokyoNight Night" ;;
	gruvbox-dark) echo "Gruvbox Dark" ;;
	kanagawa) echo "Kanagawa Wave" ;;
	everforest) echo "Everforest Dark Hard" ;;
	*) echo "Catppuccin Mocha" ;;
	esac
}

# Ghostty cursor color: most prevalent accent per theme
get_ghostty_cursor_color() {
	case "$1" in
	catppuccin-mocha) echo "#b4befe" ;; # lavender
	dracula) echo "#bd93f9" ;;          # purple
	nord) echo "#88c0d0" ;;             # frost
	rose-pine) echo "#c4a7e7" ;;        # iris
	tokyo-night) echo "#7aa2f7" ;;      # blue
	gruvbox-dark) echo "#fe8019" ;;     # orange
	everforest) echo "#a7c080" ;;       # green
	kanagawa) echo "#7e9cd8" ;;         # wave blue
	*) echo "#b4befe" ;;
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
mkdir -p "$XDG_CONFIG_HOME/jj"
link "$DOTFILES/jj/config.toml" "$XDG_CONFIG_HOME/jj/config.toml"

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

# Apply theme to config files via sed
echo ""
info "Applying theme: $THEME..."

# .zshenv: update THEME export
sed -i '' "s/^export THEME=\".*\"/export THEME=\"$THEME\"/" "$DOTFILES/.zshenv"

# yazi/theme.toml: update flavor
YAZI_FLAVOR="$(get_yazi_flavor "$THEME")"
sed -i '' "s/^dark = \".*\"/dark = \"$YAZI_FLAVOR\"/" "$DOTFILES/yazi/theme.toml"

# ghostty/config: update theme and cursor color
GHOSTTY_THEME="$(get_ghostty_theme "$THEME")"
GHOSTTY_CURSOR="$(get_ghostty_cursor_color "$THEME")"
sed -i '' "s/^theme = .*/theme = $GHOSTTY_THEME/" "$DOTFILES/ghostty/config"
sed -i '' "s/^cursor-color = .*/cursor-color = $GHOSTTY_CURSOR/" "$DOTFILES/ghostty/config"

# kitty/current-theme.conf: symlink to active theme
link "$DOTFILES/themes/$THEME/theme.kitty.conf" "$DOTFILES/kitty/current-theme.conf"

# alacritty/current-theme.toml: symlink to active theme
link "$DOTFILES/themes/$THEME/theme.alacritty.toml" "$DOTFILES/alacritty/current-theme.toml"

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

# macOS: auto-hide native menu bar (sketchybar replaces it)
echo ""
info "Configuring macOS settings..."
defaults write .GlobalPreferences _HIHideMenuBar -bool true
defaults write .GlobalPreferences AppleMenuBarVisibleInFullscreen -bool false
success "Menu bar set to auto-hide (takes effect after logout/reboot)."

# Apply changes: kill tmux server to pick up new env vars
echo ""
read -rp "Kill tmux server to apply changes? [Y/n] " answer
if [[ "${answer:-Y}" =~ ^[Yy]$ ]]; then
	tmux kill-server 2>/dev/null || true
fi

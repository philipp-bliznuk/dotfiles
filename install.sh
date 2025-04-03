#!/bin/bash

# Fail on any error
set -euo pipefail

# Formatting functions
reset_color=$(tput sgr 0)

info() {
    printf "%s[*] %s%s\n" "$(tput setaf 4)" "$1" "$reset_color"
}

success() {
    printf "%s[*] %s%s\n" "$(tput setaf 2)" "$1" "$reset_color"
}

err() {
    printf "%s[*] %s%s\n" "$(tput setaf 1)" "$1" "$reset_color"
}

warn() {
    printf "%s[*] %s%s\n" "$(tput setaf 3)" "$1" "$reset_color"
}

# Variables
BACKUP_DIR="./backup"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Packages to install
packages=(
    "alacritty"
    "bat"
    "git"
    "ghostty"
    "homebrew"
    "kitty"
    "nvim"
    "ruff"
    "starship"
    "sketchybar"
    "tmux"
    "zsh"
)
# Filter the list to include only existing directories
filtered_packages=()
for pkg in "${packages[@]}"; do
    if [ -d "./$pkg" ]; then
        filtered_packages+=("$pkg")
    fi
done

# Function to back up or remove files
backup_or_remove() {
    local src="$1"
    local dest="$BACKUP_DIR/$2"

    if [ -L "$src" ]; then
        # If it's a symlink, just remove it
        info "Removing symlink: $src"
        rm -f "$src"
    elif [ -e "$src" ]; then
        # If it's a regular file or directory, back it up
        info "Backing up $src to $dest"
        mkdir -p "$(dirname "$dest")"
        mv -f "$src" "$dest"
    fi
}

# Function to process dotfiles
process_dotfiles() {
    info "Processing dotfiles for backup and cleanup..."

    find $(printf "./%s " "${filtered_packages[@]}") -type f | while read -r file; do
        # Get the relative path for the file
        relative_path="${file#./*/}"

        # Map the file relative to $HOME
        target="$HOME/${relative_path}"

        # Backup or remove
        backup_or_remove "$target" "$relative_path"

        # Create missing directories
        mkdir -p "$(dirname "$target")"
    done

    success "Backup and cleanup complete."
}

# Function to symlink with stow
symlink_dotfiles() {
    info "Symlinking dotfiles using GNU Stow..."

    for pkg in "${filtered_packages[@]}"; do
        stow -v 1 ${pkg}
    done

    success "Dotfiles symlinked successfully."
}

# Function to install packages
install_packages() {
    info "Installing Brew packages"

    brew bundle

    success "Packages installed."
}

# Main execution
process_dotfiles
symlink_dotfiles
install_packages

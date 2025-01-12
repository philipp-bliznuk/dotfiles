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

    find . -mindepth 2 -type f | while read -r file; do
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

    find . -maxdepth 1 -mindepth 1 -type d ! -name "backup" | while read -r dir; do
        to_stow="${dir#./}"
        stow -v 1 ${to_stow}
    done

    success "Dotfiles symlinked successfully."
}

# Main execution
process_dotfiles
symlink_dotfiles

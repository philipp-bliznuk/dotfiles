#!/bin/bash

# Self-parsing theme colors at runtime.
# Reads THEME from .zshenv, loads hex values from theme.zsh,
# converts #RRGGBB → 0xFFRRGGBB for sketchybar.

THEME=$(grep -m1 '^export THEME=' "$HOME/.zshenv" 2>/dev/null | cut -d'"' -f2)
THEME=${THEME:-catppuccin-mocha}

THEME_FILE="$HOME/.config/themes/$THEME/theme.zsh"

if [[ ! -f "$THEME_FILE" ]]; then
	THEME_FILE="$HOME/.config/themes/catppuccin-mocha/theme.zsh"
fi

TRANSPARENT=0x00000000

# Parse "key "#hex"" pairs → 0xFFRRGGBB bash variables (UPPERCASE)
while IFS= read -r line; do
	if [[ "$line" =~ ^[[:space:]]*([a-z0-9]+)[[:space:]]+\"#([a-fA-F0-9]{6})\" ]]; then
		name="${BASH_REMATCH[1]}"
		hex="${BASH_REMATCH[2]}"
		upper=$(echo "$name" | tr '[:lower:]' '[:upper:]')
		declare "$upper=0xFF${hex}"
	fi
done <"$THEME_FILE"

# Semantic aliases
BAR_COLOR=$TRANSPARENT
BAR_BORDER_COLOR=$TRANSPARENT
ICON_COLOR=${TEXT:-0xFFCDD6F4}
LABEL_COLOR=${TEXT:-0xFFCDD6F4}
HIGHLIGHT=${OVERLAY1:-0xFF7F849C}
BACKGROUND_COLOR=${BASE:-0xFF1E1E2E}

# Semi-transparent variants (0x60 = ~38% opacity)
POPUP_BACKGROUND_COLOR="0x60${SURFACE1#0xFF}"
POPUP_BORDER_COLOR=${OVERLAY0:-0xFF6C7086}
BACKGROUND_BORDER_COLOR="0x60${SURFACE2#0xFF}"

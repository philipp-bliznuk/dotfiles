#!/bin/bash

# Poll-based media display via media-control get.
# Runs every update_freq seconds.
# Never toggles drawing state — always drawn, shows/hides via label content.

INFO=$(media-control get 2>/dev/null)

if [[ -z "$INFO" ]]; then
	sketchybar --set "$NAME" label="" icon.drawing=off
	exit 0
fi

PLAYING=$(echo "$INFO" | jq -r '.playing // false')
TITLE=$(echo "$INFO" | jq -r '.title // empty')
ARTIST=$(echo "$INFO" | jq -r '.artist // empty')

if [[ "$PLAYING" == "true" && -n "$TITLE" ]]; then
	MEDIA="${ARTIST:+$ARTIST - }$TITLE"
	sketchybar --set "$NAME" label="$MEDIA" icon.drawing=on
else
	sketchybar --set "$NAME" label="" icon.drawing=off
fi

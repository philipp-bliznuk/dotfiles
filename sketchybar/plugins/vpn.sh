#!/bin/bash

CONNECTED=$(/usr/local/bin/mullvad status 2>/dev/null | grep -c "Connected")

ICON=􀲊
HIGHLIGHT=on
if [[ "$CONNECTED" -gt 0 ]]; then
	ICON=􀙨
	HIGHLIGHT=off
fi

sketchybar --set "$NAME" icon="$ICON" icon.highlight=$HIGHLIGHT

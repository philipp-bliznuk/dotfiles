#!/bin/bash

VPN_STATUS=$(scutil --nwi | grep -E '^   utun[0-9]')

if [ -n "$VPN_STATUS" ]; then
    ICON="􀙨"
    HIGHLIGHT=off
else
    ICON="􀲊"
    HIGHLIGHT=on
fi
sketchybar --set $NAME icon="$ICON" icon.highlight="$HIGHLIGHT"

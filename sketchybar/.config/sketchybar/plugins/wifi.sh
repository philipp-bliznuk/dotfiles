#!/bin/bash

IP="$(ipconfig getsummary en0 | grep -o "yiaddr = .*" | sed 's/^yiaddr = //')"

if [ -n "$IP" ]; then
    ICON=􀙇
    HIGHLIGHT=off
else
    ICON=􀙈
    HIGHLIGHT=on
fi

sketchybar --set $NAME icon="$ICON" icon.highlight="$HIGHLIGHT"

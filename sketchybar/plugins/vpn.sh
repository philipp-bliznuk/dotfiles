#!/bin/bash

# VPN_STATUS=$(scutil --nwi | grep -E '^   utun[0-9]')
MULLVAD_JSON=$(curl -s https://am.i.mullvad.net/json)
VPN_STATUS=$(echo $MULLVAD_JSON | jq -r .'mullvad_exit_ip')

ICON=􀲊
HIGHLIGHT=on
if [ -n "$VPN_STATUS" ]; then
    ICON=􀙨
    HIGHLIGHT=off
fi

sketchybar --set $NAME icon=$ICON icon.highlight=$HIGHLIGHT

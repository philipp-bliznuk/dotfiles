#!/bin/bash

source "$CONFIG_DIR/colors.sh"

wifi=(
    script="$PLUGIN_DIR/wifi.sh"
)
vpn=(
    update_freq=5
    script="$PLUGIN_DIR/vpn.sh"
)
bracket=(
    background.border_color=$MAGENTA
)

sketchybar --add item wifi right \
    --set wifi "${wifi[@]}" \
    --subscribe wifi wifi_change \
    \
    --add item vpn right \
    --set vpn "${vpn[@]}" \
    \
    --add bracket network wifi vpn \
    --set network "${bracket[@]}"

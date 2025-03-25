#!/bin/bash

battery=(
    update_freq=120
    updates=on
    icon.font.family="SF Pro"
    script="$PLUGIN_DIR/battery.sh"
)

sketchybar --add item battery right \
    --set battery "${battery[@]}" \
    --subscribe battery power_source_change system_woke

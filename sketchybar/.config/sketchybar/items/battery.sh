#!/bin/bash

battery=(
    script="$PLUGIN_DIR/battery.sh"
)

sketchybar --add item battery right \
    --set battery "${battery[@]}" \
    --subscribe battery power_source_change system_woke

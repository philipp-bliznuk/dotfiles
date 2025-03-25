#!/bin/bash

disk=(
    icon=󱛟
    update_freq=300
    script="$PLUGIN_DIR/disk.sh"
)

sketchybar --add item disk left \
    --set disk "${disk[@]}"

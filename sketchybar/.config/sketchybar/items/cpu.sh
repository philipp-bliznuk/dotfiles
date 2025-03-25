#!/bin/bash

cpu=(
    icon=
    update_freq=3
    label.width=50
    label.align=right
    script="$PLUGIN_DIR/cpu.sh"
)

sketchybar --add item cpu left \
    --set cpu "${cpu[@]}"

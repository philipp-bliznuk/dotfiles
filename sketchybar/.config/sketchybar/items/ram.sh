#!/bin/bash

ram=(
    icon=
    update_freq=3
    script="$PLUGIN_DIR/ram.sh"
)

sketchybar --add item ram left \
    --set ram "${ram[@]}"

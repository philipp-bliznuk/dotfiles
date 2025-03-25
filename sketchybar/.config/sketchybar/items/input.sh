#!/bin/bash

input=(
    script="$PLUGIN_DIR/input.sh"
)

sketchybar --add event input_change 'AppleSelectedInputSourcesChangedNotification' \
    --add item input right \
    --set input "${input[@]}" \
    --subscribe input input_change

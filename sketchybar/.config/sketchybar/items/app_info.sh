#!/bin/bash

app=(
    icon="$2"
    update_freq=30
    script="$PLUGIN_DIR/app_info.sh $1"
)

sketchybar --add item $1 right \
    --set $1 "${app[@]}"

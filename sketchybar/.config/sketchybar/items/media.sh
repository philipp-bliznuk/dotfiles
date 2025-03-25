#!/bin/bash

media=(
    icon=""
    script="$PLUGIN_DIR/media.sh"
    label.max_chars=25
    scroll_texts=on
    updates=on
)

sketchybar --add item media left \
    --set media "${media[@]}" \
    --subscribe media media_change

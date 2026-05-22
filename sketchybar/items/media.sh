#!/bin/bash

# Event-driven media: uses polling via update_freq.
# No background daemon needed.

media=(
	icon=
	icon.color=$SKY
	label.max_chars=35
	scroll_texts=on
	update_freq=1
	script="$PLUGIN_DIR/media.sh"
)

sketchybar --add item media left \
	--set media "${media[@]}"

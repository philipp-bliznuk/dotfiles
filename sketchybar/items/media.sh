#!/bin/bash

# Event-driven media: subscribes to custom event fired by media-stream.sh daemon.
# No polling. Label only updates when track/state actually changes.

media=(
	icon=
	icon.color=$SKY
	icon.drawing=off
	label.max_chars=35
	scroll_texts=on
	script="$PLUGIN_DIR/media.sh"
)

sketchybar --add event media_changed \
	--add item media left \
	--set media "${media[@]}" \
	--subscribe media media_changed

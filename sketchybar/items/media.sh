#!/bin/bash

# Event-driven media: launches background stream daemon,
# subscribes to custom event for real-time updates.

sketchybar --add event media_stream_changed

media=(
	icon=
	icon.color=$SKY
	label.max_chars=35
	scroll_texts=on
	drawing=off
	script="$PLUGIN_DIR/media.sh"
)

sketchybar --add item media left \
	--set media "${media[@]}" \
	--subscribe media media_stream_changed

# Launch background stream (kill existing instances first)
pkill -f "mediaremote-adapter" 2>/dev/null
pkill -f "media_stream.sh" 2>/dev/null
sleep 0.2
"$PLUGIN_DIR/media_stream.sh" &
disown

#!/bin/bash

# Event-driven media display.
# Triggered by custom event "media_changed" from media-stream.sh daemon.
# Env vars: $title, $artist, $playing

if [[ "$playing" == "true" && -n "$title" ]]; then
	MEDIA="${artist:+$artist - }$title"
	sketchybar --set "$NAME" label="$MEDIA" icon.drawing=on
else
	sketchybar --set "$NAME" label="" icon.drawing=off
fi

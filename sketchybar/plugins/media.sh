#!/bin/bash

# Event-driven media display via media-control stream.
# Receives TITLE, ARTIST, PLAYING env vars from media_stream_changed event.

# Update label if we have title info
if [[ -n "$TITLE" ]]; then
	MEDIA="${ARTIST:+$ARTIST - }$TITLE"
	sketchybar --set "$NAME" label="$MEDIA"
fi

# Only toggle drawing when PLAYING state is explicitly provided
if [[ "$PLAYING" == "true" ]]; then
	sketchybar --set "$NAME" drawing=on
elif [[ "$PLAYING" == "false" ]]; then
	sketchybar --set "$NAME" drawing=off
fi

#!/bin/bash

# Background daemon: streams media changes via media-control,
# fires sketchybar custom event on each update.

media-control stream 2>/dev/null | while IFS= read -r line; do
	# Skip events with empty payload
	empty=$(echo "$line" | jq -r 'if .payload == {} then "yes" else "no" end' 2>/dev/null)
	[[ "$empty" == "yes" ]] && continue

	title=$(echo "$line" | jq -r '.payload.title // empty' 2>/dev/null)
	artist=$(echo "$line" | jq -r '.payload.artist // empty' 2>/dev/null)
	playing=$(echo "$line" | jq -r 'if .payload.playing != null then (.payload.playing | tostring) else empty end' 2>/dev/null)

	if [[ -n "$title" || -n "$playing" ]]; then
		sketchybar --trigger media_stream_changed \
			TITLE="${title:-}" ARTIST="${artist:-}" PLAYING="${playing:-false}"
	fi
done

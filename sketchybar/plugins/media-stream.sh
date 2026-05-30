#!/bin/bash

# Event-driven media daemon for sketchybar.
# Runs media-control stream, parses JSON events, triggers sketchybar custom event.
# Uses PID file for single-instance guarantee + pgrep for self-cleanup.

PIDFILE="/tmp/sketchybar-media-stream.pid"

# Single-instance check: verify PID is alive AND is our script
if [[ -f "$PIDFILE" ]]; then
	old_pid=$(cat "$PIDFILE" 2>/dev/null)
	if [[ -n "$old_pid" ]] && kill -0 "$old_pid" 2>/dev/null &&
		ps -p "$old_pid" -o args= 2>/dev/null | grep -q "media-stream"; then
		exit 0
	fi
fi
echo $$ >"$PIDFILE"

cleanup() {
	rm -f "$PIDFILE"
	exit 0
}
trap cleanup TERM INT EXIT

title=""
artist=""
playing="false"

update_sketchybar() {
	sketchybar --trigger media_changed \
		title="$title" \
		artist="$artist" \
		playing="$playing"
}

while pgrep -q sketchybar; do
	while IFS= read -r line; do
		# Check if sketchybar still alive inside inner loop
		pgrep -q sketchybar || exit 0

		payload_empty=$(jq -r 'if (.payload | length) == 0 then "true" else "false" end' <<<"$line")

		if [[ "$payload_empty" == "true" ]]; then
			title=""
			artist=""
			playing="false"
		else
			new_title=$(jq -r 'if .payload.title then .payload.title else empty end' <<<"$line")
			new_artist=$(jq -r 'if .payload.artist then .payload.artist else empty end' <<<"$line")
			new_playing=$(jq -r 'if .payload.playing != null then (.payload.playing | tostring) else empty end' <<<"$line")

			if [[ -n "$new_title" && "$new_title" != "null" ]]; then
				title="$new_title"
			fi
			if [[ -n "$new_artist" && "$new_artist" != "null" ]]; then
				artist="$new_artist"
			fi
			if [[ -n "$new_playing" && "$new_playing" != "null" ]]; then
				playing="$new_playing"
			fi
		fi

		update_sketchybar
	done < <(media-control stream 2>/dev/null)

	# If media-control stream exits, wait before retry
	sleep 2
done

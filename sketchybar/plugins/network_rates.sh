#!/bin/bash

INTERFACE="en0"
PREV_FILE="/tmp/sketchybar_net_prev"

# Read current bytes
read -r rx tx <<<"$(netstat -ibn | awk -v iface="$INTERFACE" '$1 == iface && $3 ~ /^<Link/ {print $7, $10; exit}')"

if [[ -z "$rx" || -z "$tx" ]]; then
	sketchybar --set net.down label="- B/s" --set net.up label="- B/s"
	exit 0
fi

# Read previous values (if exist)
if [[ -f "$PREV_FILE" ]]; then
	read -r prev_rx prev_tx prev_time <"$PREV_FILE"
	now=$(date +%s)
	elapsed=$((now - prev_time))

	if [[ $elapsed -gt 0 ]]; then
		down=$(((rx - prev_rx) / elapsed))
		up=$(((tx - prev_tx) / elapsed))
	else
		down=0
		up=0
	fi
else
	down=0
	up=0
fi

# Store current values
echo "$rx $tx $(date +%s)" >"$PREV_FILE"

human_readable() {
	local bytes=$1
	if [[ $bytes -ge 1073741824 ]]; then
		printf "%.1f GB/s" "$(echo "scale=1; $bytes/1073741824" | bc)"
	elif [[ $bytes -ge 1048576 ]]; then
		printf "%.1f MB/s" "$(echo "scale=1; $bytes/1048576" | bc)"
	elif [[ $bytes -ge 1024 ]]; then
		printf "%.1f KB/s" "$(echo "scale=1; $bytes/1024" | bc)"
	else
		printf "%d B/s" "$bytes"
	fi
}

sketchybar --set net.down label="$(human_readable $down)" \
	--set net.up label="$(human_readable $up)"

#!/bin/bash

# Calculate used memory % (active + wired + compressed) / total physical RAM
PAGE_SIZE=$(vm_stat | head -1 | grep -oE "[0-9]+")
STATS=$(vm_stat 2>/dev/null)

pages_active=$(echo "$STATS" | awk '/Pages active/ {gsub(/\./,"",$NF); print $NF}')
pages_wired=$(echo "$STATS" | awk '/Pages wired/ {gsub(/\./,"",$NF); print $NF}')
pages_compressed=$(echo "$STATS" | awk '/occupied by compressor/ {gsub(/\./,"",$NF); print $NF}')

TOTAL=$(sysctl -n hw.memsize)
USED=$(((pages_active + pages_wired + pages_compressed) * PAGE_SIZE))

if [[ $TOTAL -gt 0 ]]; then
	PERCENT=$((USED * 100 / TOTAL))
else
	PERCENT=0
fi

sketchybar --set "$NAME" label="${PERCENT}%"

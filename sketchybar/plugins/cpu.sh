#!/bin/bash

# CPU usage as percentage of total capacity (divided by core count)
CORES=$(sysctl -n hw.ncpu)
RAW=$(ps -A -o %cpu | awk '{s+=$1}END{print s}')
CPU=$(echo "$RAW $CORES" | awk '{printf "%d%%", $1/$2}')

sketchybar --set "$NAME" label="$CPU"

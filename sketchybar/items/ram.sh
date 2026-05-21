#!/bin/bash

ram=(
	icon=
	icon.color=$PEACH
	update_freq=10
	script="$PLUGIN_DIR/ram.sh"
)

sketchybar --add item ram left \
	--set ram "${ram[@]}"

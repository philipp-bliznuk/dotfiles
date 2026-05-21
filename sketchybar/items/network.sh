#!/bin/bash

wifi=(
	update_freq=5
	script="$PLUGIN_DIR/wifi.sh"
)
vpn=(
	update_freq=30
	script="$PLUGIN_DIR/vpn.sh"
)

sketchybar --add item wifi right \
	--set wifi "${wifi[@]}" \
	--subscribe wifi wifi_change system_woke \
	\
	--add item vpn right \
	--set vpn "${vpn[@]}" \
	--subscribe vpn system_woke

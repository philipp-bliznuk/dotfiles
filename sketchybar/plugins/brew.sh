#!/bin/bash

source "$CONFIG_DIR/settings.sh"

LOCKFILE="/tmp/sketchybar_brew.lock"

refresh() {
	# Prevent concurrent brew processes
	if [[ -f "$LOCKFILE" ]]; then
		return
	fi
	touch "$LOCKFILE"
	trap 'rm -f "$LOCKFILE"' RETURN

	OUTDATED=$(/bin/zsh -c 'brew outdated --verbose 2>/dev/null')

	if [[ -z "$OUTDATED" ]]; then
		sketchybar --set "$NAME" icon.color=$ICON_COLOR
		return
	fi

	args=(--set "$NAME" icon.color=$RED)
	if $(sketchybar --query "$NAME" | jq '.popup.items | length != 0'); then
		args+=(--remove '/brew.popup\..*/')
	fi

	COUNTER=0
	while IFS= read -r package; do
		args+=(
			--add item "$NAME".popup.$COUNTER popup."$NAME"
			--set "$NAME".popup.$COUNTER label="${package}"
		)
		COUNTER=$((COUNTER + 1))
	done <<<"$OUTDATED"

	sketchybar -m "${args[@]}" >/dev/null
}

update() {
	osascript -e 'display notification "Starting Brew package updates..." with title "Package Updates"'
	/bin/zsh -c 'brew upgrade >/dev/null 2>&1 && brew cleanup >/dev/null 2>&1'
	osascript -e 'display notification "Brew packages updated" with title "Package Updates"'
	sketchybar -m --set "$NAME" icon.color=$ICON_COLOR --remove '/brew.popup\..*/' >/dev/null
}

case "$SENDER" in
"routine" | "forced")
	refresh
	;;
"mouse.entered")
	popup on
	;;
"mouse.exited" | "mouse.exited.global")
	popup off
	;;
"mouse.clicked")
	popup off
	update
	;;
esac

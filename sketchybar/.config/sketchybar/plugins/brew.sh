#!/bin/bash

source "$CONFIG_DIR/settings.sh"

refresh() {
    zsh -c 'brew update &>/dev/null'
    OUTDATED=$(zsh -c 'brew outdated --verbose')

    COUNT=$(zsh -c 'brew outdated' | wc -l | tr -d ' ')
    args=(--set $NAME label=$COUNT --remove '/brew.popup\.*/')

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
    zsh -c 'brew upgrade >/dev/null && brew cleanup >/dev/null'
    osascript -e 'display notification "Brew packages updated" with title "Package Updates"'
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
    refresh
    ;;
esac

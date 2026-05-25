#!/bin/bash

source "$CONFIG_DIR/colors.sh"

FONT="JetBrainsMono Nerd Font"
PADDINGS=3

bar=(
	height=35
	color=$BAR_COLOR
	border_color=$BAR_BORDER_COLOR
	display=main
)

default=(
	updates=on

	icon.font.family="$FONT"
	icon.font.style="Bold"
	icon.font.size=14.0
	icon.color=$ICON_COLOR
	icon.highlight_color=$HIGHLIGHT
	icon.padding_left=$PADDINGS
	icon.padding_right=$PADDINGS

	label.font.family="$FONT"
	label.font.style="Semibold"
	label.font.size=13.0
	label.color=$LABEL_COLOR
	label.highlight_color=$HIGHLIGHT

	padding_right=$PADDINGS
	padding_left=$PADDINGS

	popup.align=right
	popup.background.border_width=1
	popup.background.corner_radius=5
	popup.background.border_color=$POPUP_BORDER_COLOR
	popup.background.color=$POPUP_BACKGROUND_COLOR

	background.corner_radius=5
	background.height=25
	background.border_width=1
)

popup_events=(
	mouse.entered
	mouse.exited
	mouse.exited.global
)

popup() {
	sketchybar --set "$NAME" popup.drawing="$1"
}

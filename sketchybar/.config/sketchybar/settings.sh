#!/bin/bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

FONT="JetBrainsMono Nerd Font"
PADDINGS=3 # All paddings use this value (icon, label, background)

bar=(
    height=35
    blur_radius=30

    corner_radius=0

    position=top

    # sticky=off
    sticky=on

    padding_left=10
    padding_right=10

    color=$TRANSPARENT
    # topmost=window
    topmost=off

    shadow=off

    border_width=2
    # border_color=$BAR_BORDER_COLOR
    border_color=$TRANSPARENT

    notch_width=170
)

default=(
    updates=when_shown

    icon.font.family="$FONT"
    icon.font.style="Bold"
    icon.font.size=14.0
    icon.color=$ICON_COLOR
    icon.highlight_color=$GREY
    icon.padding_left=$PADDINGS
    icon.padding_right=$PADDINGS

    label.font.family="$FONT"
    label.font.style="Semibold"
    label.font.size=13.0
    label.color=$LABEL_COLOR
    label.highlight_color=$GREY
    label.padding_left=$PADDINGS
    label.padding_right=$PADDINGS

    padding_right=$PADDINGS
    padding_left=$PADDINGS

    background.height=26
    background.corner_radius=9
    background.border_width=2

    popup.align=right
    popup.background.border_width=1
    popup.background.corner_radius=3
    popup.background.border_color=$POPUP_BORDER_COLOR
    popup.background.color=$POPUP_BACKGROUND_COLOR
    # popup.background.shadow.drawing=on
    popup.blur_radius=20

    scroll_texts=on
)

popup_events=(
    mouse.entered
    mouse.exited
    mouse.exited.global
)

popup() {
    sketchybar --set "$NAME" popup.drawing="$1"
}

# menu_item_defaults=(
#     label.font="$FONT:Regular:12"
#
#     padding_left=$PADDINGS
#     padding_right=$PADDINGS
#
#     icon.padding_left=0
#     icon.padding_right=4
#     icon.color=$HIGHLIGHT
#
#     background.color=$TRANSPARENT
#     scroll_texts=on
# )
#
#
# # Item Defaults
# item_defaults=(
#   background.padding_left=$(($PADDINGS / 2))
#   background.padding_right=$(($PADDINGS / 2))
#   background.height=20
#   icon.padding_left=0
#   icon.padding_right=0
#   icon.background.corner_radius=4
#   icon.font="$FONT:Regular:11"
#   icon.color=$ICON_COLOR
#   icon.highlight_color=$HIGHLIGHT
#   label.font="$FONT:Regular:11"
#   label.color=$LABEL_COLOR
#   label.highlight_color=$HIGHLIGHT
#   label.padding_left=$(($PADDINGS / 2))
#   updates=when_shown
#   scroll_texts=on
#   background.corner_radius=4
# )
#
# icon_defaults=(
#   label.drawing=off
# )
#
# notification_defaults=(
#   updates=on
#   update_freq=300
#   background.padding_left=$PADDINGS
#   background.padding_right=$PADDINGS
#   label.drawing=off
# )
#
# bracket_defaults=(
#   background.color="$(getcolor grey 50)"
# )
#
# menu_defaults=(
#   popup.blur_radius=32
#   popup.background.color=$POPUP_BACKGROUND_COLOR
#   popup.background.corner_radius=$PADDINGS
#   popup.background.shadow.drawing=on
#   popup.background.shadow.color=$(getcolor black 50)
#   popup.background.shadow.angle=90
#   popup.background.shadow.distance=16
# )
#
# menu_item_defaults=(
#   label.font="$FONT:Regular:12"
#   padding_left=$PADDINGS
#   padding_right=$PADDINGS
#   icon.padding_left=0
#   icon.padding_right=4
#   icon.color=$HIGHLIGHT
#   background.color=$TRANSPARENT
#   scroll_texts=on
# )
#
# separator=(
#   background.height=1
#   width=180
#   background.color="$(getcolor white 25)"
#   background.y_offset=-16
# )

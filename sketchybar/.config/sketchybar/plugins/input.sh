#!/bin/bash

SOURCE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID)

case ${SOURCE} in
'com.apple.keylayout.ABC')
    LABEL=US
    ;;
'com.apple.keylayout.Ukrainian-PC')
    LABEL=UA
    ;;
'com.apple.keylayout.Russian')
    LABEL=RU
    ;;
esac

sketchybar --set $NAME label="$LABEL"

#!/bin/bash

STATUS_LABEL=$(lsappinfo info -only StatusLabel "$1")
if [[ $STATUS_LABEL =~ \"label\"=\"([^\"]*)\" ]]; then
    LABEL="${BASH_REMATCH[1]}"
else
    exit 0
fi

sketchybar --set $NAME label="${LABEL}"

#!/bin/env bash

STATUS_FILE="$XDG_RUNTIME_DIR/night-light.status"

if [ ! -f "$STATUS_FILE" ]; then
    echo "FALSE" > "$STATUS_FILE"
fi

TOGGLE=$(cat "$STATUS_FILE")

pkill -x hyprsunset 2>/dev/null

if [ "$TOGGLE" = "FALSE" ]; then
    hyprsunset -t 4000 &
    echo "TRUE" > "$STATUS_FILE"
else
    hyprsunset -t 6500 &
    echo "FALSE" > "$STATUS_FILE"
fi


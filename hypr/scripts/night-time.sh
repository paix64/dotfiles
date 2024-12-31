#!/bin/env bash

killall -q hyprsunset

# Get the current hour (in 24-hour format)
current_hour=$(date +%H)

# If it’s 17:00 to 8:00, -t 5000
if [ "$current_hour" -ge 17 ] || [ "$current_hour" -le 7 ]; then
  echo "Changing to nighttime hyprsunset"
  hyprsunset -t 4000
else
  echo "Changing to default hyprsunset"
  hyprsunset -t 6500
fi

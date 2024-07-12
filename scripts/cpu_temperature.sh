#!/bin/bash

# by Paul Colby (http://colby.id.au), no rights reserved ;)

# Temperature inputs.
TEMP_INPUT=$(echo /sys/class/hwmon/hwmon8/temp*_input)

PREV_TOTAL=0
PREV_IDLE=0

while true; do
  # Get the total CPU statistics, discarding the 'cpu ' prefix.
  CPU=(`sed -n 's/^cpu\s//p' /proc/stat`)
  IDLE=${CPU[3]} # Just the idle CPU time.

  # Calculate the total CPU time.
  TOTAL=0
  for VALUE in "${CPU[@]}"; do
    let "TOTAL=$TOTAL+$VALUE"
  done

  # Calculate the CPU usage since we last checked.
  let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"

  # Calculate highest CPU Temperature.
  HIGH_TEMP=$(echo "scale=1; $(sort -r $TEMP_INPUT | head -n1) / 1000" | bc)

  # Redirect CPU temperature and % of CPU usage to file.
  echo "$(date '+%H:%M:%S'): +${HIGH_TEMP}°C ${DIFF_USAGE}%"

  # Remember the total and idle CPU times for the next check.
  PREV_TOTAL="$TOTAL"
  PREV_IDLE="$IDLE"
    # Wait before checking again.
  sleep 5
done

#!/bin/env bash

# Check if acpi command is available
if ! command -v acpi &> /dev/null; then
    echo "Error: acpi command not found. Install acpi package and try again."
    exit 1
fi

if ! command -v bc &> /dev/null; then
    echo "Error: bc command not found. Install bc package and try again."
    exit 1
fi

# Extract remaining capacity, status, and time remaining from acpi output
remaining_capacity=$(acpi -b | head -n 1 | awk '{print $4}' | tr -d '%,')
remaining_capacity_plugged=$(acpi -b | head -n 1 | grep -o '[0-9]\+%'| head -n 1)
status=$(acpi -b | head -n 1 | awk '{print $3}' | tr -d ',')
time_remaining=$(acpi -b | head -n 1 | awk '{print $5}')
current_power=$(echo "scale=2; $(cat /sys/class/power_supply/BAT0/power_now) / 1000000" | bc)
battery_health=$(acpi -i | head -n 2 | grep 'last full capacity' | awk -F'=' '{print $2}')

# Check if the battery is discharging
if [[ "$status" != "Discharging" ]]; then
    echo -e "\033[0;32m$remaining_capacity_plugged\033[0m [AC]"
    exit 0
fi

# Check if time remaining is available
if [[ -z "$time_remaining" ]]; then
    echo "Error: Failed to retrieve time remaining."
    exit 1
fi

echo " $time_remaining  $current_power-W  $remaining_capacity% $battery_health"

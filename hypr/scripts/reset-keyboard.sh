#!/usr/bin/env bash

reset_keyboard() {
    hyprctl keyword '$KB_ENABLED' "false" -r
    hyprctl keyword '$KB_ENABLED' "true" -r
}

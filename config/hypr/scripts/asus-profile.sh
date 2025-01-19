#!/bin/bash

asusctl profile -n
PROFILE=$(asusctl profile -p | grep Active)

notify-send "$PROFILE"

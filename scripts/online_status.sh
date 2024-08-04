#!/bin/bash

if ping -c 1 google.com 2>/dev/null | grep -q '1 received'; then
    echo " Online" 
    exit 0
else
    echo " Offline"
    exit 1
fi

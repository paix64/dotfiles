#!/bin/bash

if ping -c 1 google.com 2>/dev/null | grep -q '1 received'; then
	mkdir -p log
    echo " Online" > ./log/status.log
    exit 0
else
	mkdir -p log
    echo " Offline" > ./log/status.log
    exit 1
fi

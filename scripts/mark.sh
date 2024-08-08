#!/bin/bash

DATE=$(date +%F_%H:%M:%S)
NAME=$1

mkdir -p "/tmp/mark/"
touch "/tmp/mark/${NAME}_${DATE}"

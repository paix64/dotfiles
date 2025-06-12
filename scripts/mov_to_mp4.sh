#!/usr/bin/env bash

for file in *.[mM][oO][vV]
do
  mod_datetime=$(stat -c %y "$file" | sed 's/ /_/g; s/:/-/g; s/\..*//')
  mkdir -p output
  ffmpeg -i "$file" -c:v h264_nvenc -crf 23 -preset fast -c:a aac \
  "output/${mod_datetime}.mp4" 
done

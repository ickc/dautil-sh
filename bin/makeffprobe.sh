#!/usr/bin/env bash

# find all video files under current directory
# use ffprobe to get format and streams in json
# write to .json as a sidecar to the original file

find -type f -regextype posix-egrep -regex "^.*(.mp4|.rmvb|.mkv|.ts|.avi|.m2ts|.wmv|.mpg)$" -exec bash -c '
  for inFile do
    ffprobe -v quiet -print_format json -show_format -show_streams "$inFile" > "${inFile%.*}.json"
  done' bash {} +

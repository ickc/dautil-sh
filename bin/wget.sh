#!/usr/bin/env bash

# usage: wget.sh urls.txt PATTERN
# where urls.txt contains urls, one per line.
# and PATTERN is the name to append the url as a file name
# e.g. the url in urls.txt might be http://example.com/abc/
# which would save a file to http://example.com/abc/index.html
# then PATTERN is index.html

while read LINE; do
    filePath="${LINE##*//}$2"
    [[ -e "$filePath" ]] && echo "$filePath exists." || wget --recursive --level=1 --convert-links --continue "$LINE"
done < "$1"

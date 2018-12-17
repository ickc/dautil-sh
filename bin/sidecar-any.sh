#!/usr/bin/env bash

usage="${BASH_SOURCE[0]} [-h] [-i INPUTEXTENSION] [-d DIRECTORY] --- print any sidecars

where:
	-h	show this help message
	-i	input extension
	-d	directory to find. If not specified, current directory.

Per file with input extension, find any sidecar with the same filename and print to stdout.
"

# getopts ##############################################################

# reset getopts
OPTIND=1

# get the options
while getopts "i:n:dh" opt; do
	case "$opt" in
	i)	inExt="$OPTARG"
		;;
	d)	dir="$OPTARG"
		;;
	h)	printf "%s\n" "$usage"
		exit 0
		;;
	*)	printf "%s\n" "$usage"
		exit 1
		;;
	esac
done


if [[ -z "$inExt" ]]; then
	printf "%s\n" '-i is required.' >&2
	exit 1
fi

if [[ -z "$dir" ]]; then
	dir=.
fi

EXT=$inExt find "$dir" -name "*.$inExt" -exec bash -c '
  for inFile do
    printf "%s\n" "${inFile%.*}".* | grep -v ".$EXT"
  done' bash {} +

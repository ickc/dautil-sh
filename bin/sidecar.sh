#!/usr/bin/env bash

usage="${BASH_SOURCE[0]} [-h] [-i INPUTEXTENSION] [-o OUTPUTEXTENSION] [-d DIRECTORY] --- print missing sidecars

where:
	-h	show this help message
	-i	input extension
	-o	output extension.
	-d	directory to find. If not specified, current directory.

Per file with input extension, expect a sidecar with this output extension. If not exist, print it to stdout.
"

# getopts ##############################################################

# reset getopts
OPTIND=1

# get the options
while getopts "i:o:n:dh" opt; do
	case "$opt" in
	i)	inExt="$OPTARG"
		;;
	o)	outExt="$OPTARG"
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


if [[ -z "$inExt" || -z "$outExt" ]]; then
	printf "%s\n" '-i -o are required.' >&2
	exit 1
fi

if [[ -z "$dir" ]]; then
	dir=.
fi

OUTEXT=$outExt find "$dir" -name "*.$inExt" -exec bash -c '
  for inFile do
    expectedFile="${inFile%.*}.$OUTEXT"
    if [[ ! -e "$expectedFile" ]]; then
      printf "%s\n" "$expectedFile"
    fi
  done' bash {} +

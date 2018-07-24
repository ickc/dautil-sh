#!/usr/bin/env bash

usage="${BASH_SOURCE[0]} [-h] [-i INPUTEXTENSION] [-o OUTPUTEXTENSION] [-d DIRECTORY] --- compare 2 directories and print differences

where:
	-h	show this help message
	-i	input directory.
	-o	output directory.
	-e	(optional) file extension to look for.
	-b	basename of files only.

print the diff. of the content between input/output directories, with
optional extension.
"

# getopts ##############################################################

# reset getopts
OPTIND=1

# get the options
while getopts "i:o:n:e:bh" opt; do
	case "$opt" in
	i)	inDir="$OPTARG"
		;;
	o)	outDir="$OPTARG"
		;;
	e)	ext="$OPTARG"
		;;
	b)	useBasename=true
		;;
	h)	printf "%s\n" "$usage"
		exit 0
		;;
	*)	printf "%s\n" "$usage"
		exit 1
		;;
	esac
done


if [[ -z "$inDir" || -z "$outDir" ]]; then
	printf "%s\n" '-i -o are required.' >&2
	exit 1
fi

if [[ -n "$ext" ]]; then
	args='-name "*.$ext"'
fi

if [[ -n "$useBasename" ]]; then
	comm -3 <(cd $inDir; find $args -exec basename {} \; | sort) <(cd $outDir; find $args -exec basename {} \; | sort)
else
	comm -3 <(cd $inDir; find $args | sort) <(cd $outDir; find $args | sort)
fi



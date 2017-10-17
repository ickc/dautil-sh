#!/usr/bin/env bash

usage="${BASH_SOURCE[0]} [-h] [-i INPUTDIRECTORY] [-e EXT] [-l LEVEL] [-s SEP] --- Print a summary of files with extension per subdirectories

where:
	-h	show this help message
	-i	input directory. Default: current directory.
	-e	file extension to search for.
	-l	level of subdirectories. Default: 1
	-s	separator of the output table. Default: ,
"

# getopts ##############################################################

# reset getopts
OPTIND=1

inDir=.
level=1
sep=,

# get the options
while getopts "hi:e:l:s:" opt; do
	case "$opt" in
	i)	inDir="$OPTARG"
		;;
	e)	ext="$OPTARG"
		;;
	l)	level="$OPTARG"
		;;
	s)	sep="$OPTARG"
		;;
	h)	printf "$usage"
		exit 0
		;;
	*)	printf "$usage"
		exit 1
		;;
	esac
done

if [[ -z "$ext" ]]; then
	printf "%s\n" '-e is required.' >&2
	exit 1
fi

########################################################################

printf "%s$sep" "directory" "n" "total size" && printf "%s\n" "average size"

ext="$ext" sep="$sep" find "$inDir" -mindepth "$level" -maxdepth "$level" -type d -exec bash -c '
	for dir do
		n="$(find "$dir" -iname "*.$ext" | wc -l)"
		if [[ "$n" == 0 ]]; then
			sizes=0
			size=0
		else
			sizes="$(find "$dir" -iname "*.$ext" -print0 | xargs -0 stat -c %s | paste -d+ -s | bc)"
			size="$(($sizes / $n))"
		fi
		sizes="$(numfmt --to=iec-i --suffix=B "$sizes")"
		size="$(numfmt --to=iec-i --suffix=B "$size")"
		printf "%s$sep" "${dir#./*}" "$n" "$sizes" && printf "%s\n" "$size"
	done' bash {} + | sort

#!/usr/bin/env bash

usage="${BASH_SOURCE[0]} [-h] [-i INPUTDIRECTORY] [-e EXT] [-p pattern] [-l LEVEL] [-s SEP] --- Print a summary of files with extension per subdirectories. v0.1

where:
	-h	show this help message
	-i	input directory. Default: current directory.
	-e	file extension to search for.
	-p	pattern to search for. Override -e if both are specified.
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
while getopts "hi:e:p:l:s:" opt; do
	case "$opt" in
	i)	inDir="$OPTARG"
		;;
	e)	ext="$OPTARG"
		;;
	p)	pattern="$OPTARG"
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

if [[ -z "$ext" && -z "$pattern" ]]; then
	printf "%s\n" '-e or -p is required.' >&2
	exit 1
fi

if [[ -n "$ext" ]]; then
	if [[ -n "$pattern" ]]; then
		printf "%s\n" "-p $pattern override -e $ext." >&2
	else
		pattern="*.$ext"
	fi
fi

########################################################################

printf "%s$sep" "directory" "n" "total size" && printf "%s\n" "average size"

pattern="$pattern" sep="$sep" find "$inDir" -mindepth "$level" -maxdepth "$level" -type d -exec bash -c '
	for dir do
		n="$(find "$dir" -iname "$pattern" | wc -l)"
		if [[ "$n" == 0 ]]; then
			sizes=0
			size=0
		else
			sizes="$(find "$dir" -iname "$pattern" -print0 | xargs -0 stat -c %s | paste -d+ -s | bc)"
			size="$(($sizes / $n))"
		fi
		sizes="$(numfmt --to=iec-i --suffix=B "$sizes")"
		size="$(numfmt --to=iec-i --suffix=B "$size")"
		printf "%s$sep" "${dir#./*}" "$n" "$sizes" && printf "%s\n" "$size"
	done' bash {} + | sort

#!/usr/bin/env bash

usage="${BASH_SOURCE[0]} [-nOh] [-d DIRECTORY] [-i INPUTEXTENSION] [-o OUTPUTEXTENSION] --- finding sidecars.

where:
	-h	show this help message.
	-d	directory to find. If not specified, current directory.
	-i	input extension.
	-o	output extension.
	-n	negation. Find files without sidecar.
	-O	if specified, show the original file instead.

Per file with input extension, find sidecar with alternative extension.
e.g.
Find all missing sidecar with output extension given input extension.
${BASH_SOURCE[0]} -i INEXT -o OUTEXT -n
Find all sidecars of files with extension
${BASH_SOURCE[0]} -i INEXT
Find all files without any sidecar
${BASH_SOURCE[0]} -i INEXT -n -O
"

# getopts ##############################################################

# reset getopts
OPTIND=1

dir=.

# get the options
while getopts "d:i:o:nOh" opt; do
	case "$opt" in
	d)	dir="$OPTARG"
		;;
	i)	inExt="$OPTARG"
		;;
	o)	outExt="$OPTARG"
		;;
	n)	neg=True
		;;
	O)	original=True
		;;
	h)	printf "%s\\n" "$usage"
		exit 0
		;;
	*)	printf "%s\\n" "$usage"
		exit 1
		;;
	esac
done

printerr () {
	printf "%s\\n" "$@" >&2
	exit 1
}

if [[ -z "$inExt" ]]; then
	printerr '-i is required.'
fi


########################################################################

export OUTEXT="$outExt"
export INEXT="$inExt"

if [[ -n "$outExt" ]]; then
	if [[ -n "$neg" ]]; then
		if [[ -n "$original" ]]; then
			execString='
			for inFile do
				expectedFile="${inFile%.*}.$OUTEXT"
				if [[ ! -e "$expectedFile" ]]; then
				printf "%s\\n" "$inFile"
				fi
			done'
		else
			execString='
			for inFile do
				expectedFile="${inFile%.*}.$OUTEXT"
				if [[ ! -e "$expectedFile" ]]; then
				printf "%s\\n" "$expectedFile"
				fi
			done'
		fi
	else
		if [[ -n "$original" ]]; then
			execString='
			for inFile do
				expectedFile="${inFile%.*}.$OUTEXT"
				if [[ -e "$expectedFile" ]]; then
				printf "%s\\n" "$inFile"
				fi
			done'
		else
			execString='
			for inFile do
				expectedFile="${inFile%.*}.$OUTEXT"
				if [[ -e "$expectedFile" ]]; then
				printf "%s\\n" "$expectedFile"
				fi
			done'
		fi
	fi
else
	if [[ -n "$neg" ]]; then
		if [[ -n "$original" ]]; then
			# note that this is slow because of the subshell, but still faster than calling `find`
			execString='
			for inFile do
				(( $(printf "%s\\n" "${inFile%.*}".* | wc -l) == 1 )) && echo $inFile
			done'
		else
			printerr 'Without output extension with negation, only original can be shown.'
		fi
	else
		if [[ -n "$original" ]]; then
			# note that this is slow because of the subshell, but still faster than calling `find`
			execString='
			for inFile do
				(( $(printf "%s\\n" "${inFile%.*}".* | wc -l) > 1 )) && echo $inFile
			done'
		else
			execString='
			for inFile do
				printf "%s\\n" "${inFile%.*}".* | grep -v ".$INEXT$"
			done'
		fi
	fi
fi

find "$dir" -name "*.$inExt" -exec bash -c "$execString" bash {} +

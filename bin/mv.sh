#!/usr/bin/env bash

usage="${BASH_SOURCE[0]} [-hd] [-i INPUTDIRECTORY] [-o OUTPUTDIRECTORY] [-n NAME] --- find & mv while preserving directory structure

where:
	-h	show this help message
	-n	name or a pattern of name. e.g. '*.pdf'
	-i	input directory: 'NAME' will be searched within this directory.
	-o	output directory: files matched will be moved to this directory, preserving the directory structure in 'INPUTDIRECTORY'.
	-d	if specified, remove empty directories in 'INPUTDIRECTORY' after files moved.

Note:
	this script should be safe for arbitrary filenames including special characters.
	realpath is needed to resolve from relative paths. Install and put it in your PATH if it is missing.

"

# getopts ##############################################################

# reset getopts
OPTIND=1

deleteEmptyDir=False

# get the options
while getopts "i:o:n:dh" opt; do
	case "$opt" in
	i)	inDirPrefix="$OPTARG"
		;;
	o)	outDirPrefix="$OPTARG"
		;;
	n)	name="$OPTARG"
		;;
	d)	deleteEmptyDir=True
		;;
	h)	printf "$usage"
		exit 0
		;;
	*)	printf "$usage"
		exit 1
		;;
	esac
done

if [[ -z "$inDirPrefix" || -z "$outDirPrefix" || -z "$name" ]]; then
	printf "%s\n" '-i -o -n are all required.' >&2
	exit 1
fi

########################################################################

# get abspath and export as env. var.
export inDirPrefix=$(realpath "$inDirPrefix")
export outDirPrefix=$(realpath "$outDirPrefix")

cd "$inDirPrefix" && find . -name "$name" -exec bash -c '
	for file do
		inDir="$inDirPrefix/$file"
		outDir=$(dirname "$outDirPrefix/$file")
		mkdir -p "$outDir"
		mv "$inDir" "$outDir"
	done' bash {} +

if [[ $deleteEmptyDir == True ]]; then
	find "$inDirPrefix" -type d -empty -delete
fi

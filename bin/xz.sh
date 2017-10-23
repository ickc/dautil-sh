#!/usr/bin/env bash
# get paths and extension
inFile="$@"
inFileWoExt=${inFile%.*}
Ext=${inFile##*.}

for compression in {0..9}; do
	for extreme in None extreme; do
		if [[ $extreme == extreme ]]; then
			outFile="$inFileWoExt-$compression-extreme.$Ext.xz"
			xz -k -$compression -e "$inFile"
			mv "$inFile.xz" "$outFile"
		else
			outFile="$inFileWoExt-$compression.$Ext.xz"
			xz -k -$compression "$inFile"
			mv "$inFile.xz" "$outFile"
		fi
	done
done

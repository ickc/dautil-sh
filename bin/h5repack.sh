#!/bin/bash
# get paths and extension
inFile="$@"
inFileWoExt=${inFile%.*}
Ext=${inFile##*.}

for FILT in SHUF FLET NBIT NONE; do
	outFile="$inFileWoExt-$FILT.$Ext"
	h5repack -f $FILT "$inFile" "$outFile"
done

FILT=GZIP
for compression in {0..9}; do
	outFile="$inFileWoExt-$FILT-$compression.$Ext"
	h5repack -f $FILT=$compression "$inFile" "$outFile"
done

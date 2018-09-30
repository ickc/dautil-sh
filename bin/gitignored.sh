#!/usr/bin/env bash

find -type d -name '\.git' -exec bash -c '
	for gitDir do
		inDir="${gitDir%/*}"
		cd "$inDir"
		git status --porcelain=2 --ignored | grep "^!" | awk -v inDir="$inDir" "{print inDir \"/\" substr(\$0,3)}"
		cd - > /dev/null
	done' bash {} +

#!/usr/bin/env bash

# find all subdirectories which are git repos, and put to stdout all ignored files.

find -type d -name '\.git' -exec bash -c '
	for git do
		dir="${git::-4}"
		cd "$dir"
		git status --porcelain=2 --ignored | grep "^[!?]" | awk -v dir="$dir" "{print dir substr(\$0,3)}"
		cd - > /dev/null
	done' bash {} +

#!/usr/bin/env bash

# find all subdirectories which are git repos, and put to stdout if and only if the working tree is not clean.
# i.e. it shows the git repos that "requires your attention".

find -type d -name '.git' -exec bash -c '
	for git do
		dir="${git::-4}"
		if [[ $(cd "$dir" && git status --porcelain) ]]; then
			echo "$dir"
		fi
	done' bash {} +

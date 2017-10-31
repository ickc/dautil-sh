#!/usr/bin/env bash

# find all subdirectories which are git repos, and put to stdout if and only if it isn't pushed to remote.

find -type d -name '.git' -exec bash -c '
	for git do
		dir="${git::-4}"
		if [[ $(cd "$dir" && git log --branches --not --remotes --simplify-by-decoration --decorate --oneline) ]]; then
			echo "$dir"
		fi
	done' bash {} +

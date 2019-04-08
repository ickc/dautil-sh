#!/usr/bin/env bash

set -e

localBasePath='/Volumes/'
remoteBasePath='/'
relativePath=''
server=''

usage="./$(basename "$0") [-nh] [-i local-base-path] [-o remote-base-path] [-r relative-path] --- show diff. between directory between input and output directory.

where:
	-h	show this help message

	-i	Local base directory. Default: $localBasePath
	-o	Remote base directory. Default: $remoteBasePath
	-r	relative path to base directory. Default: $relativePath
	-s	server address. Default: '$server'. Leave it as '' if not using ssh.

	-n	normalize. If specified, normalize the unicode to formD before making comparison.
"

# getopts ######################################################################

# reset getopts
OPTIND=1

# get the options
while getopts "ni:o:r:s:h" opt; do
	case "$opt" in
    n)  normalize=True
        ;;
	i)	localBasePath="$OPTARG"
		;;
	o)	remoteBasePath="$OPTARG"
		;;
	r)	relativePath="$OPTARG"
		;;
    s)  server="$OPTARG"
        ;;
	h)	printf "$usage"
		exit 0
		;;
	*)	printf "$usage"
		exit 1
		;;
	esac
done

########################################################################

if [[ -n "$normalize" ]]; then
    if [[ -n "$server" ]]; then
        comm -3 <(cd "${localBasePath}${relativePath}" && find | iconv -f utf8 -t utf8-mac | sort) <(ssh "$server" "cd "${remoteBasePath}${relativePath}" && find" | iconv -f utf8 -t utf8-mac | sort)
    else
        comm -3 <(cd "${localBasePath}${relativePath}" && find | iconv -f utf8 -t utf8-mac | sort) <(cd "${remoteBasePath}${relativePath}" && find | iconv -f utf8 -t utf8-mac | sort)
    fi
else
    if [[ -n "$server" ]]; then
        comm -3 <(cd "${localBasePath}${relativePath}" && find | sort) <(ssh "$server" "cd "${remoteBasePath}${relativePath}" && find" | sort)
    else
        comm -3 <(cd "${localBasePath}${relativePath}" && find | sort) <(cd "${remoteBasePath}${relativePath}" && find | sort)
    fi
fi

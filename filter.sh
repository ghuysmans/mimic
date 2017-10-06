#!/bin/sh
if [ -z "$1" ]; then
	echo usage: $0 input [filter] >&2
	exit 1
fi

tshark -n -r "$1" -O pgsql "$2" |
grep -v "^\\(Frame\\|Ethernet\\)"

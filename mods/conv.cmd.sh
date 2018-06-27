#! /usr/bin/env pata

conv() {
	if [ $# -lt 2 ]; then
		echo >&2 "Usage: conv <from> <to> [args...]"
		return 1
	fi
	Require "conv/$1/$2"
	local name="$1_to_$2";shift 2
	Cmd "$name" "$@"
}

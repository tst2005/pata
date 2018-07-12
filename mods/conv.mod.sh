#! /usr/bin/env pata

PATA_MOD_PREFIX='conv_'
PATA_MOD_DEFAULT='conv' # that will make a conv_default() { conv_conv "$@"; }

conv_conv() {
	if [ $# -lt 2 ]; then
		echo >&2 "Usage: conv <from> <to> [args...]"
		return 1
	fi
	if [ "$1" = raw ]; then
		Require "encode/$2"
	elif [ "$2" = raw ]; then
		Require "decode/$1"
	else
		Require "conv/$1/$2"
	fi
	local name="$1_to_$2";shift 2
	Cmd "$name" "$@"
}

conv_encode() {
	if [ $# -lt 1 ]; then
		echo >&2 "Usage: encode <to>"
		return 1
	fi
	conv_conv raw "$1"
}
conv_decode() {
	if [ $# -lt 1 ]; then
		echo >&2 "Usage: decode <from>"
		return 1
	fi
	conv_conv "$1" raw
}

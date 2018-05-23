#!/bin/sh

STARTPWD="$(pwd)"
cd -- "$(dirname -- "$0")/.." || exit 1
BASEDIR="$(pwd)"
cd -- "$STARTPWD"

PATA_DIR="$BASEDIR"
. "$PATA_DIR/lib/pata.lib.sh"

if [ $# -eq 0 ]; then
	if [ -t 0 ]; then
		echo >&2 "Usage: $0 file"
		exit 1
	fi
	set -- /dev/stdin
fi

case "$1" in
	(/*) ;;
	(*) f="$STARTPWD/$1"; shift; set -- "$f" "$@" ;;
esac
if [ ! -r "$1" ]; then
	echo >&2 "No such $1"
	exit 1
fi

pata builtin InLoad core/default

pata builtin In 'mods'

. "$1"


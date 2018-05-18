#!/bin/sh

STARTPWD="$(pwd)"
cd -- "$(dirname -- "$0")" || exit 1
BASEDIR="$(pwd)"
cd -- "$STARTPWD"

PATA_DIR="$BASEDIR"
. "$PATA_DIR/pata.lib.sh"

if [ -z "$1" ]; then
	echo >&2 "Usage: $0 file"
	exit 1
fi
if [ ! -f "$STARTPWD/$1" ]; then
	echo >&2 "No such $1"
	exit 1
fi

pata builtin Load pata/default
In 'mods'

. "$STARTPWD/$1"


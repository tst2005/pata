#!/bin/sh

#STARTPWD="$(pwd)"
#cd -- "$(dirname -- "$0")/.." || exit 1
#BASEDIR="$(pwd)"
#cd -- "$STARTPWD"

#PATA_DIR="$BASEDIR"
#PATA_LIBFILE="$PATA_DIR/lib/pata.lib.sh"

pata_search() {
	for found in "$PATA_DIR/$3" "$1/$3" "$1/../$3"; do
		if [ $2 "$found" ]; then
			return 0
		fi
	done
	return 1
}
basedir="$(readlink 2>&- -f "$0")"
basedir="$(dirname -- "${basedir:-$0}")"

if pata_search "$basedir" -r lib/pata.lib.sh; then
	PATA_LIBFILE="$found"
else
	echo >&2 "$0: unable to find lib/$2"
	exit 1
fi
if pata_search "$basedir" -d mods; then
	PATA_MODSDIR="$found"
else
	echo >&2 "$0: unable to find mods directory"
	exit 1
fi
if pata_search "$(pwd)" -d mods; then
	PATA_MODSDIR2="$found"
else
	PATA_MODSDIR2=''
fi

case "$PATA_LIBFILE" in
	(/*) . "$PATA_LIBFILE" ;;
	(*)  . "./$PATA_LIBFILE" ;;
esac
PATA_ARG0="$0"

pata_bin "$@"

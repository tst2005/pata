#!/bin/sh

main() {
	cd "$(dirname -- "$0")" || exit 1
	local err=0
	for f in './required/'*; do
		[ -f "$f" ] || continue
		. "$f"
		cmd="require_$(basename -- "$f" .sh)"
		"$cmd" || err=1
	done
	return $err
}

main &&
echo ok || echo ERROR

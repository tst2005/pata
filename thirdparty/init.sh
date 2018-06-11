#!/bin/sh

update_xml2json() {
	rmdir 2>&- xml2json

	if [ ! -d xml2json ]; then
		git clone https://github.com/hay/xml2json
	fi

	if [ -d xml2json ]; then
		(
		cd xml2json &&
		git pull -q
		) &&
		return 0
	fi
	return 1
}

update_csv2json() {
	[ -d csv2json ]
}

main() {
	cd "$(dirname -- "$0")" || exit 1
	local err=0
	for f in "$@"; do
		"$f" || err=1
	done
	return $err
}

main \
	update_xml2json \
	update_csv2json

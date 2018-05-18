PATA_GET() {
	# GET <name> input
	if [ $# -eq 2 ] && [ "$2" = "input" ]; then
		load inputs
		"$1"
		return $?
	fi
	case "$1" in
		(output)
			load output
			shift
		;;
		(input)
			load inputs
			shift
		;;
		(stdin|-)
			if [ $# -ne 1 ]; then
				echo >&2 "Wrong syntax: stdin does not support additionnal argument"
				return 1
			fi
			cat
			return 0
		;;
		(*)
			load inputs
			if ! command >/dev/null 2>&1 -v "$1"; then
				echo >&2 "ERROR"
				return 1
			fi
		;;
	esac
	ChainOrDefault "$@"
}

PATA_FILTER() {
	load filters
	ChainOrDefaultInput "$@"
}

PATA_CONVERT() {
	load convert
	ChainOrDefaultInput "$@"
}

PATA_COLUMN() {
	load column
	ChainOrDefaultInput "$@"
}

PATA_OUTPUT() {
	GET output "$@"
}

#PATABUILTINcreate() {
#	local callname="$1" loadname="$2"
#	eval 'PATABUILTIN_'"$callname"'() { load '"$loadname"'; ChainOrDefaultInput "$@"; }; '"$callname"'() { PATABUILTIN_'"$callname"' "$@"; }'
#}
#PATABUILTINcreate COL "column"

pata builtin Load "$DIR/$NAME/short"

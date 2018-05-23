
PATA_MOD_PREFIX='PATA_'

PATA_DEBUG() {
	pata builtin InLoad "base/debug";
}

PATA_INPUT() {
	load input
	ChainOrDefaultInput "$@"
}

PATA_OUTPUT() {
	load output
	ChainOrDefault "$@"
}

PATA_GET() {
	# GET <name> input
	if [ $# -eq 2 ] && [ "$2" = "input" ]; then
		load input
		"$1"
		return $?
	fi
	case "$1" in
		(output)
			shift
			PATA_OUTPUT "$@"
			return $?
		;;
		(input)
			shift
			PATA_INPUT "$@"
			return $?
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
			load input
			if ! command >/dev/null 2>&1 -v "$1"; then
				echo >&2 "ERROR"
				return 1
			fi
			ChainOrDefault "$@"
		;;
	esac
}

PATA_FILTER() {
	load filter
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


#PATABUILTINcreate() {
#	local callname="$1" loadname="$2"
#	eval 'PATABUILTIN_'"$callname"'() { load '"$loadname"'; ChainOrDefaultInput "$@"; }; '"$callname"'() { PATABUILTIN_'"$callname"' "$@"; }'
#}
#PATABUILTINcreate COL "column"

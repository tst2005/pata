
pata_builtin() {
		local self=pata_builtin
		case "$1" in
			(CmdExists)
				shift; command >/dev/null 2>&1 -v "$1"
			;;
			(IN)
				shift
				local new="$1"
				case "$1" in
				(':'*) new="$NAMESPACE/${1#:}";;
				esac
				if [ ! -e "$new" ]; then
					echo >&2 "No such namespace $new"
					return 1
				fi
				NAMESPACE="$new";
			;;
			(load) shift; . ./${NAMESPACE:+$NAMESPACE/}$1.cmd.sh;;
			(Chain)
				shift
				if [ $# -gt 1 ]; then
					local a1="$1";shift
					$self Chain "$a1" | $self Chain "$@";
					return $?
				fi
				if [ "$1" != : ]; then
					"$1";
				fi
			;;
			(DefaultOrChain)
				shift
#				if [ $# -eq 0 ]; then
#					$self Chain default
#					return $?
#				fi
				$self Chain "${@:-default}"
			;;
			(DefaultInputOrChain)
				shift
				{
					if [ -t 0 ]; then # currently no input data
						if $self CmdExists "default"; then
							defaultInput
						else
							echo >&2 "ERROR: no data and no defaultInput available"
							return 1
						fi
					else
						cat
					fi
				} | $self DefaultOrChain "$@"
			;;
			(*)
#				local cmd="PATABUILTIN_$1"
#				if command >/dev/null 2>&1 -v "$cmd"; then
					echo >&2 "pata: builtin $1 not found"
					return 1
#				fi
#				shift
#				"$cmd" "$@"
			;;
		esac
}

pata() {
	if [ "$1" = buildin ]; then
		echo >&2 "typo? buildin instead of builtin ?"; return 124
	fi
	if [ "$1" = builtin ]; then
		shift;
		pata_builtin "$@"
		return $?
	fi

	local cmd="$1";shift;
	case "$cmd" in
		(CmdExists|IN|load|Chain|DefaultOrChain|DefaultInputOrChain)
			cmd="PATABUILTIN_$cmd"
		;;
		(GET|FILTER|CONVERT|COLUMN|OUTPUT)
			cmd="PATA_$cmd"
		;;
		(*)
			echo >&2 "pata: unsupported command $cmd";return 12
		;;
	esac

	case "$cmd" in
	(PATA_PATA_*)
		echo >&2 "ERROR loop detected? $cmd"
		return 123
	;;
	esac

	if command >/dev/null 2>&1 -v "$cmd"; then
		"$cmd" "$@"
	else
		case "$cmd" in
			(PATABUILTIN_*) pata builtin "$cmd";return $?;;
		esac
		echo >&2 "pata: command $cmd not found"
		return 1
	fi
}


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
	DefaultOrChain "$@"
}

PATA_FILTER() {
	load filters
	DefaultInputOrChain "$@"
}

PATA_CONVERT() {
	load convert
	DefaultInputOrChain "$@"
}

PATA_COLUMN() {
	load column
	DefaultInputOrChain "$@"
}

PATA_OUTPUT() {
	GET output "$@"
}

#PATABUILTINcreate() {
#	local callname="$1" loadname="$2"
#	eval 'PATABUILTIN_'"$callname"'() { load '"$loadname"'; DefaultInputOrChain "$@"; }; '"$callname"'() { PATABUILTIN_'"$callname"' "$@"; }'
#}
#PATABUILTINcreate COL "column"

before() {
	# there is nothing in stdin
	if [ -t 0 ]; then
		if [ -f /tmp/fifo ]; then
			cat /tmp/fifo
		else
			echo >&2 "nothing to get"
		fi
	else # there is data in stdin
		cat
	fi
}
after() {
	# there is no command to receive stdout, write it into fifo
	if [ -t 1 ]; then
		cat > /tmp/fifo.tmp
		mv /tmp/fifo.tmp /tmp/fifo
	else # there is something piped over stdout, just pass the data to the next piped command 
		cat
	fi
}
middle() {
	before | after
}

CmdExists() { pata_builtin CmdExists "$@"; }
load() { pata_builtin load "$@"; }
IN() { pata_builtin IN "$@"; }
Chain() { pata_builtin Chain "$@"; }
DefaultOrChain() { pata_builtin DefaultOrChain "$@"; }
DefaultInputOrChain() { pata builtin DefaultInputOrChain "$@"; }
GET() { pata GET "$@"; }
FILTER() { pata FILTER "$@"; }
CONVERT() { pata CONVERT "$@"; }
COLUMN() { pata COLUMN "$@"; }
OUTPUT() { pata OUTPUT "$@"; }


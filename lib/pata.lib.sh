pata_builtin() {
		local self='pata builtin'
		case "$1" in
			(CmdExists)
				shift; command >/dev/null 2>&1 -v "$1"
			;;
			(In)
				shift
				local new
				case "$1" in
				('-')	new="$OLDNAMESPACE"	;;
				(':'*)	new="$NAMESPACE/${1#:}"	;;
				(*)	new="$1";shift		;;
				esac
				if [ -n "$new" ] && [ ! -e "$new" ]; then
					echo >&2 "$self: No such namespace $new"
					return 1
				fi
				OLDNAMESPACE="$NAMESPACE"
				NAMESPACE="$new"
			;;
			(Load)
				shift
#echo >&2 "# I am $NAMESPACE/$DIR/$NAME : I am loading $NAMESPACE/$1"
				local DIR="$(dirname "$1")" NAME="$(basename "$1")" NAMESPACE="$NAMESPACE"
				. "./${NAMESPACE:+$NAMESPACE/}/$1.cmd.sh"
			;;
			(InLoad)
				shift
				local OLDNAMESPACE="$NAMESPACE"
				local r=0
				$self In "$(dirname -- "$1")" &&
				$self Load "$(basename -- "$1")";
				r=$?
				$self In -
				return $r
			;;
			# Create a function named NAME that will call the real function PREFIX_NAME
			(PrefixFunc)
				shift
				local prefix="$1";shift
				[ -z "$prefix" ] ||
				for name in "$@"; do
					eval ''"$name"'() { '"$prefix""$name"' "$@"; }'
				done
			;;
			# Execute a command with all name translation stuff
			(Cmd)
				shift
				if [ $# -ge 1 ] && [ "$1" = : ]; then
					return 0
				fi
				local hand="${PATA_COMMAND_HANDLER:-Aliaser}"
				local cmd ret
				if ! command >/dev/null 2>&1 -v "$hand"; then
					cmd="$1";shift
				else
					if ! cmd="$("$hand" "$1")"; then
						echo >&2 "ERROR: PATA_COMMAND_HANDLER=$hand fail"
						return 1
					fi
					[ -n "$cmd" ] || cmd="$1"
					shift
				fi
				"$cmd" "$@"
			;;
			# <- Chain foo bar buz
			# -> got: foo | bar | buz
			(Chain)
				shift
				while [ $# -gt 0 ]; do
					case "$1" in
						('#'*) shift;;
						(*) break ;;
					esac
				done
				if [ $# -gt 1 ]; then
					local a1="$1";shift
					$self Chain "$a1" | $self Chain "$@"
					return $?
				fi
				if [ $# -gt 0 ]; then
					if [ "$1" != : ]; then
						$self Cmd "$1"
					fi
				elif [ ! -t 0 ]; then
					cat
				fi
			;;
			(Chain2)
				shift
				while [ $# -gt 0 ]; do
					case "$1" in
						('#'*) shift;;
						(*) break ;;
					esac
				done
				local pipeline="${PATA_CHAIN_PIPELINE}"
				if [ $# -gt 1 ]; then
					local a1="$1";shift
					if ${pipeline:-false}; then
						local tmpbuf="$(mktemp $PATA_SESSION_BUFFER.XXXXXX)"
						$self Chain2 "$a1" > "$tmpbuf"
						$self Chain2 "$@" < "$tmpbuf"
						rm -f -- "$tmpbuf"
					else
						$self Chain2 "$a1"
						$self Chain2 "$@"
					fi
					return $?
				fi
				if [ $# -le 1 ]; then
					if [ "$1" != : ]; then
						$self Cmd "$1"
					fi
				elif ${pipeline:-false} && [ ! -t 0 ]; then
					cat
				fi
			;;
			(ChainOrDefault)
				shift
				if [ $# -eq 1 ] && [ "$1" = : ]; then
					return 0
				fi
				while [ $# -gt 0 ]; do
					case "$1" in
						('#'*) shift;;
						(*) break ;;
					esac
				done
#				if [ $# -eq 0 ]; then
#					$self Chain default
#				else
#					$self Chain "$@"
#				fi
				$self Chain "${@:-default}"
			;;
			(InputOrDefaultInput)
				shift
				if [ $# -eq 1 ] && [ "$1" = : ]; then
					return 0
				fi
				{
					if [ -t 0 ]; then # currently no input data
						if $self CmdExists "defaultInput"; then
							defaultInput
						else
							echo >&2 "ERROR: no data and no defaultInput available"
							return 1
						fi
					else
						cat
					fi
				}
			;;
			(ChainOrDefaultInput)
				shift
				if [ $# -eq 1 ] && [ "$1" = : ]; then
					return 0
				fi
				$self InputOrDefaultInput |
				$self ChainOrDefault "$@"
			;;
			(DefaultOrChain) echo >&2 "FIXME: rename DefaultOrChain to ChainOrDefault"; return 12;;
			(DefaultInputOrChain) echo >&2 "FIXME: rename DefaultInputOrChain to ChainOrDefaultInput"; return 13;;
			(*)
				echo >&2 "pata: builtin $1 not found"
				return 1
			;;
		esac
}

pata_command() {
	local self='pata command'
	local cmd="$1";shift
	case "$cmd" in
		(CmdExists|In|Load|Chain|ChainOrDefault|ChainOrDefaultInput|DefaultOrChain|DefaultInputOrChain|[A-Z][a-z]*)
			cmd="PATABUILTIN_$cmd"
		;;
		(GET|FILTER|CONVERT|COLUMN|OUTPUT|[A-Z][A-Z]*)
			cmd="PATA_$cmd"
		;;
		(*)
			echo >&2 "$self: unsupported command $cmd";return 12
		;;
	esac

	case "$cmd" in
	(PATA_PATA_*)
		echo >&2 "$self: ERROR: loop detected? $cmd"
		return 123
	;;
	esac

	if command >/dev/null 2>&1 -v "$cmd"; then
		"$cmd" "$@"
	else
		case "$cmd" in
			(PATABUILTIN_*) pata builtin "$cmd";return $?;;
		esac
		echo >&2 "$self: command $cmd not found"
		return 1
	fi
}
pata() {
	local self=pata
	case "$1" in
		(builtin) local a1="$1";shift;"pata_$a1" "$@";;
		(command) local a1="$1";shift;"pata_$a1" "$@";;
		(buildin) echo >&2 "$self: typo? buildin instead of builtin ?"; return 124 ;;
		(-*) echo "Usage: pata builtin|command ...";return 0;;
		(*) echo >&2 "WARNING: FIX usage from 'pata ...' to 'pata command ...' for pata $*"
			pata command "$@"
		;;
	esac
}

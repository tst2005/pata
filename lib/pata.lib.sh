pata_builtin() {
		local self='pata builtin'
		case "$1" in
			(source)
				shift
				local f="$1";shift
				set -- "$@"
				case "$f" in
				(/*|./*) .   "$f" ;;
				(*)      . "./$f" ;;
				esac
				return $?
			;;
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
				if [ -n "$PATA_MODSDIR/$new" ] && [ ! -e "$PATA_MODSDIR/$new" ]; then
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
				. "$PATA_MODSDIR/${NAMESPACE:+$NAMESPACE/}/$1.cmd.sh"
			;;
			(Require) shift
				local f=''
				for dir in "$PATA_MODSDIR2" "$PATA_MODSDIR"; do
					[ -n "$basedir" ] || continue
					if [ -r "$dir/${NAMESPACE:+$NAMESPACE/}/$1.cmd.sh" ]; then
						f="$dir/${NAMESPACE:+$NAMESPACE/}/$1.cmd.sh"
						break
					fi
				done
				if [ -z "$f" ]; then
					echo >&2 "$self[Require]: no such $1"
					return 1
				fi
				local DIR="$(dirname "$1")" NAME="$(basename "$1")" NAMESPACE="$NAMESPACE"
				. "$f"
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
				local cmd ret

				local hand="${PATA_COMMAND_HANDLER:-}"
				if [ -z "$hand" ]; then
					cmd="${PATA_MOD_PREFIX:-}$1"
				elif ! command >/dev/null 2>&1 -v "$hand"; then
					echo >&2 "$self[Cmd]: ERROR no such Alias handler PATA_COMMAND_HANDLER=$hand"
					return 1
				elif ! cmd="$("$hand" "$1")"; then
					echo >&2 "ERROR: alias handler returns a failure (PATA_COMMAND_HANDLER=$hand)"
					return 1
				fi
				[ -n "$cmd" ] || cmd="$1"
				shift
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
		(-*) echo "Usage: pata builtin|command ...";return 0;;
		(*)
			echo >&2 "WARNING: FIX usage from 'pata' to 'pata command' for 'pata $*'"
			pata command "$@"
		;;
	esac
}

pata_bin() {
	if [ $# -eq 0 ]; then
		if [ -t 0 ]; then
			echo >&2 "Usage: ${PATA_ARG0:-pata} file"
			return 1
		fi
		set -- /dev/stdin
	fi

	local app="$1";shift
	if [ ! -r "$app" ]; then
		echo >&2 "No such $app"
		return 1
	fi
	local A0="$app"
	(
		pata builtin InLoad core/default
		pata builtin In .
		pata builtin source "$app" "$@"
	)
}

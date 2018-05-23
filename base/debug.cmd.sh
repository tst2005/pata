
DebugStep() {
	local r=$?
	local self=DebugStep
	case "$1" in
	(Verbose)	PATA_STEP_VERBOSE=true;;
	(Quiet)		PATA_STEP_VERBOSE=false;;
	(Before|NotAfter) shift;
		PATA_STEP_NOTAFTER="$1";shift
	;;
	(After|NotBefore) shift;
		PATA_STEP_NOTBEFORE="$1";shift
	;;
	(Pass) shift;
		if [ ! -t 0 ]; then
			cat
		elif [ -n ${step} ] && [ ${step} -eq 1 ]; then
			DebugInput
		fi
	;;
	(Step) shift;
		local step="$1";shift
		if [ -n "${PATA_STEP_NOTAFTER:-}" ] && [ $step -gt $PATA_STEP_NOTAFTER ]; then
			$self Pass
		elif [ -n "${PATA_STEP_NOTBEFORE:-}" ] && [ $step -lt $PATA_STEP_NOTBEFORE ]; then
			$self Pass
		else
			if ${PATA_STEP_VERBOSE:-false}; then echo >&2 "# DebugStep: execute: $*";fi
			"$@"
		fi
	;;
	(*)
		echo >&2 "DebugStep: unknown command"
		return 1
	;;
	esac
	return $r
}

# Shortcut(s)
NotAfter() { DebugStep NotAfter "$@"; }
NotBefore() { DebugStep NotBefore "$@"; }
Before() { DebugStep Before "$@"; }
After() { DebugStep After "$@"; }
Pass() { DebugStep Pass "$@"; }
Step() { DebugStep Step "$@"; }
Verbose() { DebugStep Verbose "$@"; }
Quiet() { DebugStep Quiet "$@"; }

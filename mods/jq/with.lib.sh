jq_with() {
	local key="$1";shift
	local cmd="$1";shift
	local value="$1";shift
	case "$cmd" in
		('grep') echo '.'"$key"'|test("'"$value"'")' ;;
		('!grep') echo '.'"$key"'|test("'"$value"'")|not' ;;
		('='|'==')    echo '.'"$key"'=="'"$value"'"' ;;
		('!=')   echo '.'"$key"'!="'"$value"'"' ;;
		(*) echo >&2 ERROR:WTF ;;
	esac
}
jq_without() {
	local key="$1";shift
	local cmd="!$1";shift
	cmd="${cmd#!!}"
	jq_with "$key" "$cmd" "$@"
}


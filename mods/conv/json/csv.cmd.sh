
json_array_to_csv() {
	InLoad mods/jq;
	#. ./mods/jq/array_to_csv.lib.sh
	jq_array_to_csv;
}

json_object_to_csv() {
	InLoad mods/jq;
	if [ $# -eq 0 ]; then
		jqf 'object_to_array' | jq_array_to_csv
	else
		keys="$1";shift
		case "$keys" in
			('['*']') ;;
			('['*) keys="$keys"']' ;;
			(*']') keys='['"$keys" ;;
			(*)    keys='['"$keys"']' ;;
		esac
		jqf 'object_to_array('"$keys"')' | jq_array_to_csv
	fi
}
json_to_csv() {
	case "$1" in
		(array) shift; json_array_to_csv "$@";;
		(object) shift; json_object_to_csv "$@";;
		(auto) shift; echo >&2 "json_to_csv: auto not-implemented-yet";;
		(*) echo >&2 "Usage: json_to_csv array|object|auto";;
	esac
}


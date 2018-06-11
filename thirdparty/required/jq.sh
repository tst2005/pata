require_jq() {
	if ! command >/dev/null 2>&1 -v jq; then
		echo >&2 "Please install jq"
		return 1
	fi
}

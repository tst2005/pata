require_tidy() {
	if ! command >/dev/null 2>&1 -v tidy; then
		echo >&2 "Please install tidy"
		return 1
	fi
}

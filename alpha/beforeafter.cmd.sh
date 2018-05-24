PATA_MOD_PREFIX='session_'

session_begin() {
	PATA_SESSION_DIR="$(mktemp -d /tmp/pata.session.XXXXXX)"
	export PATA_SESSION_DIR

	PATA_SESSION_BUFFER="$PATA_SESSION_DIR/buff"
	if touch "$PATA_SESSION_BUFFER" && [ -f "$PATA_SESSION_BUFFER" ]; then
		export PATA_SESSION_BUFFER
	else
		PATA_SESSION_BUFFER=''
		unset PATA_SESSION_BUFFER
	fi
}
session_commit() {
	if [ -n "$PATA_SESSION_DIR" ] && [ -d "$PATA_SESSION_DIR" ]; then
		if [ -n "$PATA_SESSION_BUFFER" ] && [ -f "$PATA_SESSION_BUFFER" ]; then
			rm -f -- "$PATA_SESSION_BUFFER"
		fi
		rmdir -- "$PATA_SESSION_DIR"
	fi
}

session_before() {
	# there is nothing in stdin
	if [ -t 0 ]; then
		if [ -f "$PATA_SESSION_BUFFER" ]; then
			cat -- "$PATA_SESSION_BUFFER"
		else
			echo >&2 "nothing to get"
		fi
	else # there is data in stdin
		cat
	fi
}
session_after() {
	# there is no command to receive stdout, write it into fifo
	if [ -t 1 ]; then
		if [ -n "$PATA_SESSION_BUFFER" ] && [ -f "$PATA_SESSION_BUFFER" ]; then
			local tmpbuf="$(mktemp $PATA_SESSION_BUFFER.XXXXXX)"
			cat > "$tmpbuf"
			mv "$tmpbuf" "$PATA_SESSION_BUFFER"
		else
			echo >&2 "ERROR: no buffer"
		fi
	else # there is something piped over stdout, just pass the data to the next piped command 
		cat
	fi
}
session_middle() {
	session_before | session_after
}

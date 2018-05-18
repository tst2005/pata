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

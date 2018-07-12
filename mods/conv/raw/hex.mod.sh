
if pata builtin CmdExists od tr; then
	raw_to_hex() {
		od -t x1 -An | tr -d -c '0-9a-fA-F'
	}
else
	exit 1
fi


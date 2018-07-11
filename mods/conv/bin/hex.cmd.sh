
pata builtin CmdExists od tr && 
bin_to_hex() {
	od -t x1 -An | tr -d -c '0-9a-fA-F'
} ||
exit 1


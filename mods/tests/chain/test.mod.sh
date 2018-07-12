EnableImplicitEnd() {
	echo >&2 "# default from EnableImplicitEnd"
	default() {
		if [ $# -eq 0 ]; then
			pata builtin Chain _default implicitend
		else
			pata builtin Chain "$@" implicitend;
		fi
	}
}
foo() {
	echo "foo chaincur=${chaincur} chainsize=$chainsize";
}
bar() {
	{
	cat;
	echo "bar chaincur=${chaincur} chainsize=$chainsize";
	}
}
baz() {
	{
	cat;
	echo "baz chaincur=${chaincur} chainsize=$chainsize";
	}
}
_default() {
	echo default called;
}

if ! pata builtin CmdExists default; then
echo >&2 "# default std"
default() {
	_default "$@";
}
fi

implicitend() {
	echo >&2 "implicitend called"
	{
	md5sum
	echo "implicitend chaincur=${chaincur} chainsize=$chainsize"
	}
}

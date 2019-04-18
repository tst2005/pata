#!/bin/sh

# - remove the './' prefix
# - split('/') limit 1 : dir / rest (subpath/file:value)
# - split(':') limit 1 : subpath/file : value
# - pathtofile = dir + subpath/file
# - pathdir = pathtofile:split( last / )

#jq_function_split1='def split1($sep): [.|split($sep)|(first,(skipfirst|join($sep)))];'
#jq_function_splitn='def splitn($sep;$n): [.|split($sep)|(.[0:$n],(.[$n:]|join($sep)))];'

# RGREP
# id '/' key ':' value
# ([^/]+) '/' ([^:]+) ':' (.*)

# RGREPN
# id '/' key ':' linenum ':' value
# ([^/]+) '/' ([^:]+) ':' ([^:]+) ':' (.*)

jq_function_removeprefix='def removeprefix: if (.|startswith("./")) then (.|.[2:]) else (.) end;'
jq_function_skipfirst='def skipfirst: del(.[0]);'
jq_function_split_skipfirst='def split_skipfirst($sep): (split($sep)|skipfirst|join($sep));'

rgrepn_to_json_object() {
	jq -R . | jq -s . |
	jq '
	'"$jq_function_removeprefix"'
	'"$jq_function_skipfirst"'
	'"$jq_function_split_skipfirst"'
	map(
		removeprefix |
		{
			"dir":   (split("/")|first),
			"file":  (split_skipfirst("/")|split(":")|first),
			"n":     (split_skipfirst("/")|split_skipfirst(":")),
			"value": (split_skipfirst("/")|split_skipfirst(":")|split_skipfirst(":")),
		}
	)'
}

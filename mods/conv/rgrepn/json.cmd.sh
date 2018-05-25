
# - remove the './' prefix
# - split('/') limit 1 : dir / rest (subpath/file:value)
# - split(':') limit 1 : subpath/file : value
# - pathtofile = dir + subpath/file
# - pathdir = pathtofile:split( last / )


#- split / join
 
#- substring

#printf '["foobarbuz", 0, 4]' | jq '.[0][.[1]:.[2]]'

#- index(s), rindex(s) 

#- startswith(str)

jq_function_removeprefix='def removeprefix: if (.|startswith("./")) then (.|.[2:]) else (.) end;'
jq_function_split1='def split1($sep): [.|split($sep)|(.[0],(.[1:]|join($sep)))];'
jq_function_splitn='def splitn($sep;$n): [.|split($sep)|(.[0:$n],(.[$n:]|join($sep)))];'
# split1("sep") equal to splitn("sep";1)

rgrepn_to_json() {
	jq -R . | jq -s . |
	jq '
	'"$jq_function_removeprefix"'
	'"$jq_function_split1"'
	'"$jq_function_splitn"'
	map(
		removeprefix |
		split1("/") |
		[ .[0], (.[1]|split1(":"))] | flatten(1) |
		[ ([.[0],.[1]]|join("/")), .[2:]] | flatten(1) |
		[ .[0][0:(.[0]|rindex("/"))], .[0][(.[0]|rindex("/"))+1:], .[1:]] | flatten(1) |
		[ .[0], .[1], (.[2]|split1(":"))] | flatten(1) |
		{"id": .[0], "key": .[1], "n": .[2]|tonumber, "value": .[3]}
	)'
}

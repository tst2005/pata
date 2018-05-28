
#echo NAMESPACE=$NAMESPACE DIR=$DIR NAME=$NAME

for f in "$NAMESPACE/$DIR/$NAME"/*.lib.sh; do
	[ -e "$f" ] || continue
	#echo >&2 "- load $f"
	case "$f" in
		(/*) ;;
		(*) f="./$f" ;;
	esac
	. "$f"
done

jqf() {
        local vname="$(printf '${%s%s}' "jq_function_" "${1%%(*}")"
        #echo >&2 "jqf: vname=$vname ; $1"
        jq="$(eval echo "$vname") ${2:-$1}";
        #echo >&2 "jqf: jq=$jq"
        jq ${JQ_OPTIONS:-} "$jq";
}


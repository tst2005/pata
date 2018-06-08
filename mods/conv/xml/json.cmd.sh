xml_to_json() {
	if [ ! -x ./xml2json/xml2json.py ]; then
		echo >&2 "Missing util. No such ./xml2json/xml2json.py (Maybe git clone https://github.com/hay/xml2json ?)"
		return 1
	fi
	./xml2json/xml2json.py --strip_namespace
}

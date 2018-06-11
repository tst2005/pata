require_xml2json() {
	rmdir 2>&- xml2json

	if [ ! -d xml2json ]; then
		git clone https://github.com/hay/xml2json
	fi

	if [ -d xml2json ]; then
		(
		cd xml2json &&
		git pull -q
		) &&
		return 0
	fi
	return 1
}

# rgrep -> rgrepn -> json
pata builtin Load "$DIR/rgrepn"
pata builtin Load "$DIR/../rgrepn/$NAME"
rgrep_to_json() {
	rgrep_to_rgrepn | rgrepn_to_json;
}

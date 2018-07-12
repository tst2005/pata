# rgrep -> rgrepn -> json_object
pata builtin Load "$DIR/rgrepn"
pata builtin Load "$DIR/../rgrepn/$NAME"
rgrep_to_json_object() {
	rgrep_to_rgrepn | rgrepn_to_json_object;
}

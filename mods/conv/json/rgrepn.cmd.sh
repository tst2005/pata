json_to_rgrepn() {
	jq '
	map(
		(if (.id|startswith("/")) then ("") else ("./") end) +
		.id + "/" + .key + ":" + (.n|tostring) + ":" + .value
	)
	'|jq -r '.[]'
}

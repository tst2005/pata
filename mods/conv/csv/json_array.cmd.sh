# csv -> json_object -> json_array
pata builtin Load "$DIR/json_object"
pata builtin Load "$DIR/../json_object/$NAME"
csv_to_json_array() {
        csv_to_json_object | json_object_to_json_array;
}


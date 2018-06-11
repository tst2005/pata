#!/bin/sh

#.separator \0
SPLITIN='/'
SPLITOUT="$SPLITIN"
(
echo '
BEGIN;
CREATE temp TABLE data (
	id text,
	line text
);
'

sed -e 's,","",g' | while IFS="/" read -r id field_value; do
	echo 'INSERT INTO data values("'"$id"'","'"$field_value"'");'
done

echo 'COMMIT;'
echo 'SELECT id,line FROM data ORDER BY id ASC;'
) | sqlite3 -separator "$SPLITOUT"

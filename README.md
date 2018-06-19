# pata

Pata is an utility to helps for automation and data processing tasks.

# Made with

Mainly with

* POSIX shell (bash when POSIX is too poor)
* grep,sed,find,cut,...

But also with some thirdparty utils:

* jq (for all json stuff)
* tidy (for html to xml)
* xml2json.py (for xml to json)
* csv2json.py (for csv to json)

Some experimental stuff use:

* sqlite3 (for SQL)
* curl,wget (for download and REST API)
* ping (for network stuff)

# Convertion list

* csv/json_array ( csv/json_object + json_object/json_array )
* csv/json_object
* json_array/csv
* json_object/csv ( json_object/json_array + json_array/csv )
* json_object/json_array
* json_object/rgrep ( json/rgrepn + rgrepn/rgrep )
* json_object/rgrepn
* xml/json
* html/json
* html/xml
* rgrepn/json_object
* rgrepn/rgrep
* rgrep/json_object ( rgrep/rgrepn + rgrepn/json_object )
* rgrep/rgrepn

# Convertion matrix

| col to raw   | csv  | json_a  | json_o | xml  | html | rgrepn | rgrep |
|--------------|------|---------|--------|------|------|--------|-------|
| csv          | -    | yes     | yes    | no   | no   | no     | no    |
| json_array   | yes* | -       | yes    | -    | -    | no     | no    |
| json_object  | yes  | TODO    | -      | -    | -    | yes    | yes   |
| json(struct) | -    | -       | -      | yes  | yes  | -      | -     |
| xml          | no   | no      | no     | -    | yes  | no     | no    |
| html         | no   | no      | no     | no   |TODO**| no     | no    |
| rgrepn       | no   | no      | yes    | no   | no   | -      | yes   |
| rgrep        | no   | no      | yes    | no   | no   | yes    | -     |

(*: via convertion)
(**: via tidy )

jsonA means json array like :
```json
[
	["head1", "head2", "head3"],
	["x=1 y=1", "x=2 y=1", "x=3 y=1",
	["x=1 y=2", "x=2 y=2", "x=3 y=2"
]
```

jsonO means json Object like :
```json
[
	{"head1": "x=1 y=1", "head2": "x=2 y=1", "head3": "x=3 y=1"},
	{"head1": "x=1 y=2", "head2": "x=2 y=2", "head3": "x=3 y=2"}
]
```

# Convertion implementation alternative

## csv to json

* [csv2json.py]()
* (lua ?)

## json to csv

* jq
* (py ? lua ?)

## json to rgrepn

* jq
* (py ? lua ?)

## json to rgrep

Alias: [json to rgrepn](#json-to-rgrepn), [rgrepn to rgrep](#rgrepn-to-rgrep)

## xml to json

* [xml2json.py]()

## html to json

Alias: [html to xml](#html-to-xml), [xml to json](#xml-to-json)

## html to xml

* `tidy -asxml`

## html to html

Rewrite "bad" html to strict html.

* `tidy -ashtml`

## rgrepn to json

* jq
* (py ? lua ?)

## rgrep to rgrepn

* sh
* (py ? lua ?)

## rgrep to json

Alias: [rgrep to rgrepn](#rgrep-to-rgrepn), [rgrepn to json](#rgrepn-to-json)


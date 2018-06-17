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

# Convertion matrix

| col to raw   | csv  | json   | xml | html | rgrepn | rgrep |
|--------------|------|--------|-----|------|--------|-------|
| csv          | -    | yes    | no  | no   | no     | no    |
| json         | yes  | -      | yes | yes  | yes    | yes   |
| xml          | no   | ?      | -   | yes  | no     | no    |
| html         | no   | no     | no  | yes* | no     | no    |
| rgrepn       | no   | yes    | no  | no   | -      | yes   |
| rgrep        | no   | yes    | no  | no   | yes    | -     |

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


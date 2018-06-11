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

# pata

Pata is an utility to helps for automation and data processing tasks.

# Made with

Mainly with 

* POSIX shell (bash when POSIX is too poor)
* grep,sed,find,cut,...

But also with some thirdparty utils:

* jq (for all json stuff)
* tidy (for html to xml)
* xml2json (for xml to json)

Some experimental stuff use:

* sqlite3 (for SQL)
* curl,wget (for download and REST API)
* ping (for network stuff)

# Convertion matrix

| x to y       | (from) csv| json a | json o | xml |
|--------------|-----------|--------|--------|-----|
| (to) csv     | -         | ?      | ?      | ?   |
| json (array) | ?         | -      | ?      | ?   |
| json (object)| ?         | ?      | -      | ?   |
| xml          | ?         | ?      | ?      | -   |

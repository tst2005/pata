

CmdExists() {		pata builtin CmdExists			"$@"; }
Load() { 		pata builtin Load			"$@"; }
In() {			pata builtin In				"$@"; }
InLoad() {		pata builtin InLoad			"$@"; }
Cmd() {			pata builtin Cmd			"$@"; }
Chain() { 		pata builtin Chain			"$@"; }
ChainOrDefault() { 	pata builtin ChainOrDefault		"$@"; }
ChainOrDefaultInput() {	pata builtin ChainOrDefaultInput	"$@"; }
PrefixFunc() {		pata builtin PrefixFunc			"$@"; }
Require() {		pata builtin Require			"$@"; }

load() { 		pata builtin Load			"$@"; }
IN() { 			pata builtin In				"$@"; }

#######################################################################

Load "$(dirname "$DIR/$NAME")"
PrefixFunc "$PATA_MOD_PREFIX" INPUT OUTPUT GET FILTER CONVERT COLUMN OUTPUT DEBUG

#for f in INPUT OUTPUT GET FILTER CONVERT COLUMN OUTPUT DEBUG; do
#	pata builtin CmdExists $f && echo >&2 "$f exists" || echo >&2 "$f MISSING"
#done

pata builtin CmdExists Step || Step() { shift; "$@"; }

#PATA_MOD_PREFIX=''

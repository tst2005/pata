

CmdExists() {		pata builtin CmdExists			"$@"; }
Load() { 		pata builtin Load			"$@"; }
In() {			pata builtin In				"$@"; }
InLoad() {		pata builtin InLoad			"$@"; }
Cmd() {			pata builtin Cmd			"$@"; }
Chain() { 		pata builtin Chain			"$@"; }
ChainOrDefault() { 	pata builtin ChainOrDefault		"$@"; }
ChainOrDefaultInput() {	pata builtin ChainOrDefaultInput	"$@"; }
PrefixFunc() {		pata builtin PrefixFunc			"$@"; }

load() { 		pata builtin Load			"$@"; }
IN() { 			pata builtin In				"$@"; }

#######################################################################

Load "$(dirname "$DIR/$NAME")"
PrefixFunc "$PATA_MOD_PREFIX" GET FILTER CONVERT COLUMN OUTPUT DEBUG

#PATA_MOD_PREFIX=''

#! ./bin/pata.sh

Aliaser() { echo "$PATA_MOD_PREFIX$1"; }


patatest() { echo KO;false; }
prefixed_patatest() { echo ok;true; }

PATA_MOD_PREFIX='prefixed_'

Cmd patatest



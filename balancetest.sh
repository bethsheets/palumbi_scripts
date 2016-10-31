#!/bin/bash

ALT=$(vcffilter -f "ABP > 10 & AB > 0.5"  $1 | grep -v '#' | wc -l )
REF=$(vcffilter -f "ABP > 10 & AB < 0.5"  $1 | grep -v '#' | wc -l )
echo "alt $ALT"
echo "ref $REF"
PROP=$(bc -l <<< "($ALT/($ALT+$REF))")
echo "prop $PROP"

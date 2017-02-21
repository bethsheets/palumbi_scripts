#!/usr/bin/bash

#usage: bash grep-good-contigs.sh all_parsed.txt

BASE=$(basename ${1} .txt)
grep -v 'Bacteria' ${1} | grep -v 'Viruses' | grep -v 'Fungi' |grep -v 'Alveolata' | grep -v 'Viridiplantae' | grep -v 'Haptophyceae' | grep -v 'Euglenozoa' | cut -f1 | sort | uniq > ${BASE}_goodcontigs.txt

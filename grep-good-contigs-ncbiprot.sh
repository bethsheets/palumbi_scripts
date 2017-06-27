#!/usr/bin/bash

#usage: bash grep-good-contigs-ncbiprot.sh all_parsed.txt

BASE=$(basename ${1} .txt)
grep 'Animalia' ${1} | cut -f1 | sort | uniq > ${BASE}_goodcontigs.txt

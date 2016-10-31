#!/usr/bin/bash

#usage: sbatch grep-good-contigs.sh outfile_parsed.txt assembly.fa

BASE1=$(basename ${1} .txt)
grep -v 'Bacteria' ${1} | grep -v 'Viruses' | grep -v 'Fungi' |grep -v 'Alveolata' | grep -v 'Viridiplantae' | grep -v 'Haptophyceae' | grep -v 'Euglenozoa' | cut -f1 | sort | uniq > ${BASE}_goodcontigs.txt

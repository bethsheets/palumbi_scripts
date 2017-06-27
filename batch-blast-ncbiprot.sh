#!/bin/bash

##This script will split an assembly into batches of 1000 contigs and sumbit blastx-nr.sh for teach temp file to the cluster
#usage batch-blast-ncbiprot.sh input.fasta

awk 'BEGIN {n_seq=0;} /^>/{if(n_seq%1000==0){file=sprintf("TEMP_%d.fa",n_seq);} print >> file;n_seq++; next;} { print >> file; }' < $1

for i in TEMP*.fa; do sbatch blastx-ncbiprotein.sh  $i ; done



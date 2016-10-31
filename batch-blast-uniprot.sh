#!/bin/bash

#This script will split an assembly into batches of 500 contigs and sumbit blastx-uniprot.sh for teach temp file to the cluster 

#usage: bash batch-blast-uniprot.sh assembly.fa

awk 'BEGIN {n_seq=0;} /^>/{if(n_seq%500==0){file=sprintf("TEMP_%d.fa",n_seq);} print >> file;n_seq++; next;} { print >> file; }' < $1


for i in TEMP*.fa; do sbatch blastx-uniprot.sh $i ; done



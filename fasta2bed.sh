#!/bin/bash
#SBATCH -p owners
BASE=$(basename $1 .fa)
samtools faidx $1
awk -v OFS='\t' '{print $1,0,$2}' ${BASE}.fa.fai > ${BASE}.bed

#usage: fasta2bed.sh assembly.fa

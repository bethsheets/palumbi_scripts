#!/bin/bash
BASE=$(basename $1 .fa)
samtools faidx $1
awk -v OFS='\t' '{print $1,0,$2}' ${1}.fai > $BASE.bed

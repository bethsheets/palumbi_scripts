#!/bin/bash
echo "splitting..."
grep -v ^# $1 | awk -v D=$2 -v OFS='\t' -F'\t' '{print $2,$4,$5 > D"/"$1".snps.txt"}'
echo "compressing..."
for i in $2/*.txt; do bgzip -f $i; done

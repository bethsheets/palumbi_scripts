#!/bin/bash
echo "splitting..."
grep -v ^# $1 | awk -v OFS='\t' -v DIR=${2} -F'\t' '{print $2,$4,$5 > DIR$1".snps.txt"}'
echo "compressing..."
for i in ${2}*.txt; do bgzip $i; done

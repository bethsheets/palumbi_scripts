#!/bin/bash
bcftools view -g ^miss -q 0.05 -Q 0.95 -m2 -M2 $1 | bcftools filter -g 100 -i 'TYPE="snp"' > combined_filtered.vcf

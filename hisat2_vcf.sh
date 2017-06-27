#!/bin/bash
awk -v OFS="\t" '$3 = "rs"$1$2' $2 > TEMPhisat.vcf
hisat2_extract_snps_haplotypes_VCF.py $1 TEMPhisat.vcf $3
rm TEMPhisat.vcf

#!/bin/bash
#SBATCH -p owners,spalumbi
#SBATCH -c 4

#usage: sbatch vcftools-snpfilter.sh combined.vcf
# max-missing 1 = no missing

vcftools --vcf $1 --remove-indels --recode --recode-INFO-all --min-alleles 2 --max-alleles 2 --minGQ 20 --minDP 7 --max-missing 1 --max-maf 0.95 --maf 0.05 --out $(basename $1 .vcf)_biallelic_minMAF05_GQ20_DP7_noNA

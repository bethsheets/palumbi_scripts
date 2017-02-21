#!/bin/bash
#SBATCH -p owners
#SBATCH -c 4

#usage: sbatch vcf-filter-nomissing-maf05-qual30.sh input.vcf
#made by Noah & Beth, updated Oct 2016

#we filter for: high quality SNPs (99.9% confident), min allele freq 5%
# vcfnulldotslashdot marks SNPs with missing genotypes
# fix_freebayes_snps removes extra haplotype information from some SNPs (should only be used on prefiltered biallelic snps)
# grep removes marked missing genotypes

cat $1 | vcfnulldotslashdot \
| grep -vF './.' \
| vcffilter -f "TYPE = snp & QUAL > 30 & NUMALT = 1" \
| fix_freebayes_snps.py \
> $(basename $1 .vcf)_qual30.vcf

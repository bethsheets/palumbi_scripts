#!/bin/bash
#SBATCH -p owners
#SBATCH -c 4

#usage: sbatch vcf-filter-nomissing-maf05-allgq30.sh input.vcf #samples
#made by Noah & Beth, updated Oct 2016

#we filter for: high quality SNPs (99.9% confident), min allele freq 5%, 99.9% confident of individual genotype
# vcfnulldotslashdot marks SNPs with missing genotypes
# fix_freebayes_snps removes extra haplotype information from some SNPs (should only be used on prefiltered biallelic snps)
# grep removes marked missing genotypes

cat $1 | vcfnulldotslashdot > temp.vcf
cat temp.vcf | grep -v './.' \
| vcffilter -f "TYPE = snp & QUAL > 30 & AF > 0.05 & AF < 0.95 & NUMALT = 1" -g "GQ > 30" $1 \
| fix_freebayes_snps.py \
> $(basename $1 .vcf)_biallelic_NoNA_minMAF05_gq30.vcf
rm temp.vcf

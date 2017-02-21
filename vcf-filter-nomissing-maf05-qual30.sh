#!/bin/bash
#SBATCH -p hns,spalumbi,owners,normal
#SBATCH -t 24:00:00
#SBATCH --mem 48000
#SBATCH -c 4

#usage: sbatch vcf-filter-nomissing-maf05-qual30.sh combined.vcf


#we filter for: high quality SNPs (99.9% confident), min allele freq 5%
# vcfnulldotslashdot marks SNPs with missing genotypes
# fix_freebayes_snps removes extra haplotype information from some SNPs (should only be used on prefiltered biallelic snps)
# grep removes marked missing genotypes

cat $1 | vcfnulldotslashdot > temp.vcf
cat temp.vcf | grep -v './.' \
| vcffilter -f "TYPE = snp & QUAL > 30 & AF > 0.05 & AF < 0.95 & NUMALT = 1" temp.vcf \
| fix_freebayes_snps.py \
> $(basename $1 .vcf)_biallelic_NoNA_minMAF05_qual30.vcf
rm temp.vcf

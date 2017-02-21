#!/bin/bash
#SBATCH -p owners
#SBATCH -c 4

#usage: sbatch vcf-filter-nomissing-maf05-eSNPs.sh combined.vcf
#made by Noah & Beth, updated Oct 2016

#we filter for: high quality SNPs (99.9% confident), min allele freq 5%, at least 10 reads for each individual
# vcfnulldotslashdot marks SNPs with missing genotypes
# fix_freebayes_snps removes extra haplotype information from some SNPs (should only be used on prefiltered biallelic snps)
# grep removes marked missing genotypes

cat $1 | vcfnulldotslashdot > temp.vcf
cat temp.vcf | grep -v './.' | vcffilter -f "TYPE = snp & QUAL > 30 & AF > 0.05 & AF < 0.95 & NUMALT = 1" -g "DP > 10" temp.vcf | fix_freebayes_snps.py > $(basename $1 .vcf)_biallelic_NoNA_minMAF05_DP10.vcf
rm temp.vcf


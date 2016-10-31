#!/bin/bash 
#SBATCH --output=freebayes
#SBATCH --time=4:00:00
#SBATCH -p owners
#SBATCH --ntasks=1
#SBATCH --mem=16000

BAMS=NULL
VCFOUT=NULL
REF=NULL
CONTIGFILE=NULL
BASE=$(basename $CONTIGFILE .txt)

echo $CONTIGFILE
freebayes --genotype-qualities --use-best-n-alleles 3 -t $CONTIGFILE --vcf $VCFOUT/$BASE.vcf -f $REF $BAMS



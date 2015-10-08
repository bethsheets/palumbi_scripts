#!/bin/bash 
#
#SBATCH --time=10:00:00
#SBATCH --qos=normal
#SBATCH --ntasks=1
#SBATCH --mem=8000

BAMS=NULL
VCFOUT=NULL
REF=NULL
CONTIGFILE=NULL
BASE=$(basename $CONTIGFILE .txt)

srun $HOME/bin/freebayes --genotype-qualities --use-best-n-alleles 4 -t $CONTIGFILE --vcf $VCFOUT/$BASE.vcf -f $REF $BAMS

wait



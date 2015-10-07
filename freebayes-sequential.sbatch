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
mkdir $VCFOUT/$BASE

readarray -t CONTIGS < $CONTIGFILE
for i in "${CONTIGS[@]}"; do
    echo starting $i
    srun $HOME/bin/freebayes --genotype-qualities --use-best-n-alleles 4 -r $i --vcf $VCFOUT/$BASE/$i.vcf -f $REF $BAMS
done   

wait


vcfcombine $VCFOUT/$BASE/*.vcf > $VCFOUT/$BASE.vcf
rm -rf $VCFOUT/$BASE

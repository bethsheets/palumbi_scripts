#!/bin/bash
#usage NS-1 (or intended cutoff) qual outbase vcfs...
#SBATCH --mem 12000

vcfcombine "${@:4}" | vcffilter -f "QUAL > $2 & NS > $3" >  $1.vcf
#fix snps with padding non variant bases attached
#python $PI_HOME/scripts/fix-weird-freebayes-snps.py $2.1.vcf $2.vcf
#rm $2.1.vcf


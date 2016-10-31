#!/bin/bash
#usage NS-1 (or intended cutoff) outbase vcfs...
#SBATCH --mem 8000

vcfcombine "${@:3}" | vcffilter -f "QUAL > 30 & AF > 0.05 & AF < 0.95 & NS > $1 & TYPE = snp & NUMALT = 1" >  $2.1.vcf
#fix snps with padding non variant bases attached
python $PI_HOME/scripts/fix-weird-freebayes-snps.py $2.1.vcf $2.vcf
#rm $2.1.vcf
#vcffilter -g "GT = 0/1" $2.vcf | vcf2tsv -g > $2.tsv
vcf2tsv $2.vcf > $2.tsv

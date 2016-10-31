#!/bin/bash
module load R
NSAMPS=37
MINSAMPS=36
MINALT=3
MAXALT=$(($NSAMPS * 2 - $MINALT ))
QUAL=30
GQ=30
ABP=0
OUT=RAB-field-GQ10-NS37
NUMALT=1
echo "$@"
vcfcombine "$@" | vcfflatten | vcffilter -f "QUAL > $QUAL & TYPE = snp & AC > $MINALT & AC < $MAXALT & NUMALT = $NUMALT & ABP > $ABP" -g "GQ > $GQ" | vcffixup - |  vcffilter -f "NS > $MINSAMPS"  > $OUT.vcf
vcf2tsv -g $OUT.vcf > $OUT.tsv
bgzip < $OUT.vcf > $OUT.vcf.gz
tabix -p vcf $OUT.vcf.gz
bash $HOME/scripts/NONAtsv2txt.sh $OUT.tsv $OUT

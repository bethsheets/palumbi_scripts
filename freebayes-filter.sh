#!/bin/bash
module load R
NSAMPS=19
MINALT=1
MAXALT=$(($NSAMPS * 2 - $MINALT ))
QUAL=30
GQ=30
ABP=0
OUT=merged_GQ"$GQ"_ABP"$ABP"_SNPs_NONA
NUMALT=1
echo "$@"
vcfcombine "$@" | vcfflatten | vcffilter -f "QUAL > $QUAL & TYPE = snp & AC > $MINALT & AC < $MAXALT & NUMALT = $NUMALT & ABP > $ABP" -g "GQ > $GQ" | vcffixup - |  vcffilter -f "NS = $NSAMPS"  > $OUT.vcf
vcf2tsv -g $OUT.vcf > $OUT.tsv
bgzip < $OUT.vcf > $OUT.vcf.gz
tabix -p vcf $OUT.vcf.gz
bash $HOME/scripts/NONAtsv2txt.sh $OUT.tsv $OUT

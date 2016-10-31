freebayes -f $1 -t $2 $3 | vcffilter -f "QUAL > 30" > $3.vcf
bash $HOME/scripts/generate-WASP-snps.sh $3.vcf

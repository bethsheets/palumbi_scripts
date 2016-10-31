#!/bin/bash
module load R

echo "tsv<-read.delim(\"$1\",stringsAsFactors=F)
numsamps=tsv\$NS[1]
genomat<-matrix(tsv\$GT,ncol=numsamps,byrow=T)
genomat[genomat=='0/0']<-0
genomat[genomat=='0/1']<-1
genomat[genomat=='1/1']<-2
rownames(genomat)<-unique(paste(tsv\$CHROM,tsv\$POS,sep='-'))
colnames(genomat)<-tsv\$SAMPLE[1:numsamps]
write.table(genomat,file=\"${2}.txt\",quote=F,sep='\t')
" | R --vanilla

#!/bin/bash

module load R
KNS=8
KFDR=0.5

echo "tsv<-read.delim(\"$1\",stringsAsFactors=F)
numsamps=tsv\$NS[1]
genomat<-matrix(tsv\$GT,ncol=numsamps,byrow=T)
genomat[genomat=='0/0']<-0
genomat[genomat=='0/1']<-1
genomat[genomat=='1/1']<-2
rownames(genomat)<-unique(paste(tsv\$CHROM,tsv\$POS,sep='-'))
colnames(genomat)<-tsv\$SAMPLE[1:numsamps]
AOmat<-matrix(tsv\$AO.1,ncol=numsamps,byrow=T)
rownames(AOmat)<-unique(paste(tsv\$CHROM,tsv\$POS,sep='-'))
colnames(AOmat)<-tsv\$SAMPLE[1:numsamps]
ROmat<-matrix(tsv\$RO.1,ncol=numsamps,byrow=T)
rownames(ROmat)<-unique(paste(tsv\$CHROM,tsv\$POS,sep='-'))
colnames(ROmat)<-tsv\$SAMPLE[1:numsamps]
DPmat<-matrix(tsv\$DP.1,ncol=numsamps,byrow=T)
rownames(DPmat)<-unique(paste(tsv\$CHROM,tsv\$POS,sep='-'))
colnames(DPmat)<-tsv\$SAMPLE[1:numsamps]
AImat<-tsv[tsv\$GT=='0/1',c('CHROM','POS','SAMPLE','AO.1','RO.1','DP.1')]
AImat\$snpid<-paste(AImat\$CHROM,AImat\$POS,sep='-')
AImat\$AI=abs(0.5 - AImat\$AO.1/AImat\$DP.1)
numSamps<-sapply(unique(AImat\$CHROM),function(v) length(table(AImat[AImat\$CHROM==v,'SAMPLE'])))
goodContigs<-names(numSamps)[numSamps>$KNS]
print(AImat[AImat\$CHROM==goodContigs[1],])
print(kruskal.test(AImat[AImat\$CHROM==goodContigs[1],'AI']~factor(AImat[AImat\$CHROM==goodContigs[1],'SAMPLE']))\$p.value)
krusk<-data.frame(p=sapply(goodContigs,function(v) kruskal.test(AImat[AImat\$CHROM==v,'AI']~factor(AImat[AImat\$CHROM==v,'SAMPLE']))\$p.value))
krusk\$padj<-p.adjust(krusk\$p,method='BH')
krusk\$NS<-numSamps[numSamps>$KNS]
rownames(krusk)<-goodContigs
print(head(krusk))
ksig<-rownames(krusk)[which(krusk\$padj<$KFDR)]
AIKmat<-matrix(nrow=length(ksig),ncol=ncol(AOmat),dimnames=list(ksig,colnames(AOmat)))
print(head(AIKmat))
pdf(width=6,height=3,file=\"${2}-krusk.pdf\")
library(beeswarm)
for(con in ksig){
    curr<-AImat[AImat\$CHROM==con,]
    beeswarm(AI~SAMPLE,data=curr,main=con)
    agg<-aggregate(AI~SAMPLE,data=curr,FUN=median)
    AIKmat[con,match(as.character(agg[,1]),colnames(AIKmat))]<-agg[,2]
}
dev.off()
AImatKrusk<-AImat[AImat\$CHROM%in%ksig,]
info<-data.frame(contig=tsv\$CHROM,pos=tsv\$POS,QUAL=tsv\$QUAL,AB=tsv\$AB,ABP=tsv\$ABP)
info\$snpid<-(paste(info\$contig,info\$pos,sep='-'))
info<-info[match(unique(info\$snpid),info\$snpid),]
rownames(info)<-info\$snpid
info<-info[,colnames(info)!=\"snpid\"]
write.table(genomat,file=\"${2}.txt\",quote=F,sep='\t')
write.table(AOmat,file=\"${2}-AO.txt\",quote=F,sep='\t')
write.table(ROmat,file=\"${2}-RO.txt\",quote=F,sep='\t')
write.table(DPmat,file=\"${2}-DP.txt\",quote=F,sep='\t')
write.table(AImat,file=\"${2}-AI.txt\",quote=F,sep='\t')
write.table(AIKmat,file=\"${2}-AIK.txt\",quote=F,sep='\t')
write.table(AImatKrusk,file=\"${2}-AIkrusk.txt\",quote=F,sep='\t')
write.table(krusk,file=\"${2}-krusk.txt\",quote=F,sep='\t')
write.table(info,file=\"${2}-locus.txt\",quote=F,sep='\t')
" | R --vanilla

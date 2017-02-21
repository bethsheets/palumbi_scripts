library(DESeq2)

counts<-read.delim('merged_counts.txt',check.names=F)
rownames(counts)<-counts[,1]
counts<-counts[,-1]
meta<-read.delim('meta.txt')
print(meta)
div<-meta[,ncol(meta)]
sapply(levels(div),function(lev) write.table(rownames(meta)[div==lev],file=paste('pop',lev,'.txt',sep=''),row.names=F,col.names=F,quote=F))


form<-paste('~',paste(colnames(meta),collapse='+'))
print(form)
print(dim(counts))
print(dim(meta))
cds<-DESeqDataSetFromMatrix(counts,meta,as.formula(form))
cds<-DESeq(cds)
res<-results(cds)
write.table(rownames(res)[which(res$padj<0.05)],file='DESeq2-sig-p05.txt',quote=F,row.names=F,col.names=F)

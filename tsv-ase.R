library('permute')
library('data.table')

dat<-read.delim('HETS.tsv')
dat<-dat[,c('CHROM','POS','SAMPLE','RO.1','DP.1')]
dat$AI<-abs(0.5 - dat$RO.1/dat$DP.1)
dat$AIsign<-dat$RO.1/dat$DP.1
dat$SNP<-paste(dat$CHROM,dat$POS,sep='-')
dat$LOCUS<-paste(dat$SAMPLE, dat$SNP,sep='-')
shufTab<-function(dt,vec,response,group){
	dt$shuff<-dt[,get(response)][vec]
	return(dt[,mean(shuff),by=group][,get('V1')])
}

locTest<-function(currdat,n=100,response='AIsign',group='SNP',strata='DP.1',minGroup=2,minObs=15,two.tail=F,minDP=10){
	currdat<-currdat[currdat$DP.1>=minDP,]
	currdat<-(currdat[currdat[,group]%in%names(table(currdat[,group]))[table(currdat[,group])>=minGroup],])
        print(dim(currdat))
	if(nrow(currdat)<minObs|length(unique(currdat[,group]))<2) return(list(res=NULL,data=currdat))
	currdat$key<-1:nrow(currdat)
	currdat<-data.table(currdat)
	setkey(currdat,key)
	agg<-currdat[,list(CHROM=CHROM[1],POS=POS[1],DP.1=mean(DP.1),mean(get(response))),by=group]
	setnames(agg,5,response)
	print('shuffling...')
    perm<-shuffleSet(nrow(currdat),n,control=how(within=Within(type='free'),blocks=currdat[,get(strata)]))
    print('calculating P values...')
    if(nrow(perm)<n | min(dim(perm))<=1) return(list(res=NULL,data=currdat))
    null<-apply(perm,1,function(vec) shufTab(currdat,vec,response,group))
    testmat<-as.matrix(cbind(agg,null))[,-c(1:4)]
    if(two.tail==F) agg$p<-apply(testmat,1,function(v) length(which(v[2:length(v)]>=v[1]))/n)
	else agg$p<-apply(testmat,1,function(v) min(min(length(which(v[2:length(v)]>=v[1]))/n,length(which(v[2:length(v)]<=v[1]))/n)*2,1))
    agg$p.adj<-p.adjust(agg$p,method='BH')
    return(agg)
}
resPOS<-locTest(dat,n=5000,response='AIsign',group='SNP',strata='DP.1',minGroup=4,two.tail=T,minDP=20)
write.table(unique(resPOS[resPOS$p.adj<0.05,]$CHROM),quote=F,row.names=F,col.names=F,file='ASEcontigs.txt')
write.table(unique(resPOS[resPOS$p.adj<0.05,]$SNP),quote=F,row.names=F,col.names=F,file='ASEsnps.txt')
save(resPOS,dat,file='resPOS.Rdata')
print(table(resPOS$p.adj<0.05))


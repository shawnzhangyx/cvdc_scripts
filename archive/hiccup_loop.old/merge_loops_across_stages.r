setwd("../../analysis/hiccup_loops")
a=read.delim("combined_loops.raw.sorted.txt",stringsAsFactors=F)
options(scipen=99)

chr = c(a$chr1,a$chr2)
pos = c(a$centroid1,a$centroid2) #c(a$x1,a$y1)
#centroid = c(a$centroid1,a$centroid2)

dat = data.frame(chr,pos)
#dat = dat[!duplicated(dat[,c(1,2)]),]

dat = dat[order(dat$chr,dat$pos),]
dat$pos2 = dat$pos
pre = dat$pos[1]
for (i in 2:nrow(dat)){
print(i)
if ( abs(dat$pos[i]-pre)>30000 ) {
pre = dat$pos[i]
}
dat$pos2[i] = pre
}
centroid = aggregate(pos~chr+pos2,dat,FUN=median)
dat$centroid = centroid$pos[match(dat$pos2,centroid$pos2)]
dat2 = dat[!duplicated(dat[,c(1,2)]),]
dat2$name = paste(dat2$chr,dat2$pos)
dat2$centroid.adj = floor(dat2$centroid/1e4)*1e4


out = a
name1 = paste(out$chr1,out$centroid1)
name2 = paste(out$chr2,out$centroid2)
out$x1 = dat2$centroid.adj[match(name1,dat2$name)]
out$y1 = dat2$centroid.adj[match(name2,dat2$name)]
#out = out[order(out$chr1,out$centroid1),]

samples = aggregate(sample~chr1+x1+y1,out,FUN=function(x){length(unique(x))})

#c1 = aggregate(centroid1~chr1+x1+y1,out,FUN=median)
#c2 = aggregate(centroid2~chr1+x1+y1,out,FUN=median)
#x1 = x2 = c1
#x1$centroid1 = floor(x1$centroid1/1e4)*1e4
#x2$centroid1 = x1$centroid1 + 1e4
#y1 = y2 = c2
#y1$centroid2 = floor(y1$centroid2/1e4)*1e4
#y2$centroid2 = y1$centroid2 + 1e4

#out2 = Reduce(function(x,y){ merge(x,y, by=c("chr1","x1","y1"))},list(samples,x1,x2,y1,y2))
out3 = merge(out[,-c(7,17:20)],samples,by=c("chr1","x1","y1"))
out3 = out3[,c(1,2,4,5,3,6,7:17)]
out3$x2 = out3$x1+1e4
out3$y2 = out3$y1+1e4
colnames(out3) = c("chr1","x1","x2","chr2","y1","y2","observed","eDonut","eBL","eH","eV","fdrBL","fdrDonut","fdrH","fdrV","Samples","TotalNumSampleLoopsCalled")
out3$loopID = paste(out3$chr1,out3$x1,out3$y1)

#out4 = aggregate(Samples~loopID ,out3,FUN=paste, collapse=",",drop=F)
out4 = aggregate(Samples~loopID ,out3,FUN=function(vec){paste(unique(sort(vec)),collapse=",")},drop=F)

out5 = merge(out4,out3[,-c(7:16)],by="loopID",all.x=T,all.y=F)
out5 = out5[,c(1,3:8,2)]
require(stringr)
out5$TotalNumSampleLoopsCalled = str_count(out5$Samples,",") +1
out6 = out5[!duplicated(out5),]
out7 = merge(out3[,-17],out6,by="loopID",all.x=T,all.y=F)
write.table(out6,"loops_merged_across_samples.uniq.tab",quote=F,sep='\t',row.names=F)

write.table(out7,"loops_merged_across_samples.dup.tab",quote=F,sep='\t',row.names=F)

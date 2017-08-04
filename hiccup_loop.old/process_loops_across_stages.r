setwd("../../analysis/hiccup_loops")
a=read.delim("combined_loops.raw.sorted.txt",stringsAsFactors=F)
options(scipen=99)
out = a
out$x1[1] = out$centroid1[1]
out$y1[1] = out$centroid2[1]
pre_x = out$x1[1]
pre_y = out$y1[2]
# sort out by centroid one first.
out = out[order(out$chr1,out$centroid1),]
for (i in 2:nrow(out)){
if(i%%100==0)print(i)
if ( abs(out$centroid1[i]-pre_x)>25000 ) {
# reset pre-x
pre_x = out$centroid1[i]
}
out$x1[i] = pre_x
}
out = out[order(out$chr1,out$centroid2),]
for (i in 2:nrow(out)){
if(i%%100==0)print(i)
if ( abs(out$centroid2[i]-pre_y)>25000 ) {
# reset pre-x
pre_y = out$centroid2[i]
}
out$y1[i] = pre_y
}
out = out[order(out$chr1,out$centroid1),]


samples = aggregate(sample~chr1+x1+y1,out,FUN=function(x){length(unique(x))})

c1 = aggregate(centroid1~chr1+x1+y1,out,FUN=median)
c2 = aggregate(centroid2~chr1+x1+y1,out,FUN=median)
x1 = x2 = c1
x1$centroid1 = floor(x1$centroid1/1e4)*1e4
x2$centroid1 = x1$centroid1 + 1e4
y1 = y2 = c2
y1$centroid2 = floor(y1$centroid2/1e4)*1e4
y2$centroid2 = y1$centroid2 + 1e4

out2 = Reduce(function(x,y){ merge(x,y, by=c("chr1","x1","y1"))},list(samples,x1,x2,y1,y2))
out3 = merge(out[,-c(7,17:20)],out2,by=c("chr1","x1","y1"))
out3 = out3[,c(1,18,19,5,20,21,7:17)]
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

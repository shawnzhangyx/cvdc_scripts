setwd("../../analysis/hiccup_loops")
a=read.delim("combined_loops.raw.sorted.txt",stringsAsFactors=F)
options(scipen=99)
out = a
#out = a[,c(1:6,21)]
pre_x = out[1,2]#(out[1,2]+out[1,3])/2
pre_y = out[1,5]# (out[1,5]+out[1,6])/2
out$group = 1; pre_group = 1
for (i in 2:nrow(out)){
if(i%%100==0)print(i)
if ( abs(out[i,2]-pre_x)<25000 & abs(out[i,5]-pre_y) < 25000 ) {
#pre_x = out[i,2]; pre_y = out[i,5]
out$group[i] =pre_group
}
else { 
# reset pre-group 
pre_x = out[i,2]; pre_y = out[i,5]
pre_group = pre_group + 1; out$group[i]  = pre_group
}
}

samples = aggregate(sample~group,out,FUN=function(x){length(unique(x))})
#samples = aggregate(sample~group,out,FUN=length)

c1 = aggregate(centroid1~group,out,FUN=median)
c2 = aggregate(centroid2~group,out,FUN=median)
x1 = x2 = c1
x1$centroid1 = floor(x1$centroid1/1e4)*1e4
x2$centroid1 = x1$centroid1 + 1e4
y1 = y2 = c2
y1$centroid2 = floor(y1$centroid2/1e4)*1e4
y2$centroid2 = y1$centroid2 + 1e4
#x1 = aggregate(x1~group,out,FUN=min)
#x2 = aggregate(x2~group,out,FUN=max)
#y1 = aggregate(y1~group,out,FUN=min)
#y2 = aggregate(y2~group,out,FUN=max)

out2 = Reduce(function(x,y){ merge(x,y, by="group")},list(samples,x1,x2,y1,y2))
out3 = merge(out[,-c(7:12,17:20)],out2,by="group")
out3 = out3[,c(1,2,14,15,5,16,17,8:13)]
colnames(out3) = c("loopID","chr1","x1","x2","chr2","y1","y2","fdrBL","fdrDonut","fdrH","fdrV","Samples","TotalNumSampleLoopsCalled")
out3$loopID = paste(out3$chr1,out3$x1,out3$y1)

#out4 = aggregate(Samples~loopID ,out3,FUN=paste, collapse=",",drop=F)
out4 = aggregate(Samples~loopID ,out3,FUN=function(vec){paste(unique(sort(vec)),collapse=",")},drop=F)

out5 = merge(out4,out3[,-c(8:12)],by="loopID",all.x=T,all.y=F)
out5 = out5[,c(1,3:8,2)]
out5 = out5[!duplicated(out5),]
require(stringr)
out5$TotalNumSampleLoopsCalled = str_count(out5$Samples,",") +1
write.table(out5,"loops_merged_across_samples.tab",quote=F,sep='\t',row.names=F)


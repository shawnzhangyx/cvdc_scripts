setwd("../../analysis/tads/")
files = list.files(path="oe",pattern="oe.txt",full.names=T)
names = sub(".*(D.._HiC_Rep.).*","\\1",files)
dat = dat2 = list()
for (file in files){
print(file)
oe = data.frame(fread(file))
oe$V7 =1
#oe$upper_tri = oe$V5-oe$V4 > (oe$V3-oe$V2)/2
#oe_tri=oe[which(oe$upper_tri==TRUE),]
agg = aggregate(cbind(V6,V7)~V1+V2+V3,oe, FUN=sum)
agg$total = ((agg$V3-agg$V2)/10000/2+1)*((agg$V3-agg$V2)/10000+1)
agg$ave = agg$V6/agg$total 
dat[[file]] = agg[,c(1:3,7)]
#dat2[[file]] = aggregate(V6~V1+V2+V3,oe_tri,FUN=mean)
}

out = Reduce(function(...)merge(...,by=c("V1","V2","V3")),dat)
#out2 = Reduce(function(...)merge(...,by=c("V1","V2","V3")),dat2)
colnames(out) = c("chr","x1","x2",names)
#colnames(out2) = c("chr","x1","x2",names)
write.table(out,"combined_tads.uniq.oe_mean.txt",row.names=F,sep='\t',quote=F)
#write.table(out2,"combined_tads.uniq.oe_upper_triangle_mean.txt",row.names=F,sep='\t',quote=F)



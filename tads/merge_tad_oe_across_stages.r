setwd("../../analysis/tads/")
files = list.files(path="oe",pattern="oe.txt",full.names=T)
names = sub(".*(D.._HiC_Rep.).*","\\1",files)
dat = list()
for (file in files){
print(file)
oe = data.frame(fread(file))
dat[[file]] = aggregate(V6~V1+V2+V3,oe, FUN=mean)
}

out = Reduce(function(...)merge(...,by=c("V1","V2","V3")),dat)
colnames(out) = c("chr","x1","x2",names)
write.table(out,"combined_tads.uniq.oe_mean.txt",row.names=F,sep='\t',quote=F)


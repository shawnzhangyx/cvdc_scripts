setwd("../../analysis/tads/")
files = list.files(path="contacts_by_samples",pattern="tad.sum.txt",full.names=T)
names = sub(".*(D.._HiC_Rep.).*","\\1",files)
dat = list()
for (file in files){
dat[[file]] = data.frame(fread(file))
}

out = Reduce(function(...)merge(...,by=c("chr","x1","x2")),dat)
colnames(out)[-c(1:3)] = names
write.table(out,"combined_tads.uniq.counts.txt",row.names=F,sep='\t',quote=F)


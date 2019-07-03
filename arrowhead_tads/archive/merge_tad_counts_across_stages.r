setwd("../../analysis/tads/")
#files = list.files(path="contacts_by_samples",pattern="sum",full.names=T)
files = list.files(path="contacts_by_samples",pattern="median",full.names=T)
names = sub(".*(D.._HiC_Rep.).*","\\1",files)
dat = list()
for (file in files){
dat[[file]] = data.frame(fread(file))
}

out = Reduce(function(...)merge(...,by=c("chr","x1","x2")),dat)
#bg = (out[,seq(4,39,3)]+out[,seq(5,39,3)])/2
bg = pmax(out[,seq(4,39,3)],out[,seq(5,39,3)])

#bg = ifelse(out[,seq(4,39,3)]>out[,seq(5,39,3)],out[,seq(4,39,3)],out[,seq(5,39,3)])

ratio = out[,seq(6,39,3)]/bg
out2 = cbind(out[,1:3],ratio)
colnames(out2)[-c(1:3)] = names[seq(3,36,3)]
write.table(out2,"combined_tads.insu_median.txt",row.names=F,sep='\t',quote=F)


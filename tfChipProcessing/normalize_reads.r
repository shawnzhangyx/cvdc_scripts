setwd("../../data/tfChIPseq/counts")
options(digits=2)
options(nsmall=2)

a=data.frame(fread("CTCF.counts",skip=1))
counts = a[,-c(1:6)]
rpm = sweep(counts,2,colSums(counts),'/')*1e6
rpkm = sweep(rpm,1,a$Length,'/')*1e3
rpkm.out = cbind(a[,1:6],rpkm)

write.table(format(rpkm.out,digits=2), "CTCF.rpkm",row.names=F,sep='\t',quote=F)


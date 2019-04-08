setwd("../../analysis/hervh")

#library(tidyverse)
a=read.delim("rnaseq/hervh.merged.rnaseq.counts",skip=1)
b=read.delim('../../data/rnaseq/rerun/combined-chrM.counts',skip=1)
b$Chr = sub("(.*);(.*)","\\2",b$Chr)
b$Start = sub("(.*?);(.*)","\\1",b$Start)
b$End = sub("(.*);(.*)","\\2",b$End)
b$Strand = sub("(.*);(.*)","\\2",b$Strand)

colnames(a) = colnames(b)

a2=rbind(a,b)

rpm = sweep(a2[,7:18],2,colSums(a2[,7:18]),'/')*1e6
rpkm = sweep(rpm,1,a2$Length,'/')*1e3
rpkm2 = (rpkm[,1:6]+rpkm[,7:12])/2
colnames(rpkm2) = c("D00","D02","D05","D07","D15","D80")
rpkm3 = cbind(a2[,1:6],rpkm2)
rpkm3 = rpkm3[order(-rpkm3$D00),]

hervh = rpkm3[grep("chr",rpkm3$Geneid),]

out = rpkm3[,c(2,3,4,1,5,6,7)]
write.table(out, "D00.rna_seq.ranked_by_rpkm.v2.bed",col.names=F,row.names=F,sep="\t",quote=F)




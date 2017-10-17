setwd("../../data/chipseq/counts")

mark="H3K27ac"
for (mark in c("H3K27ac","H3K27me3","H3K4me1","H3K4me3")) {
a=data.frame(fread(paste0(mark,".counts"),skip=1))
b=read.delim(paste0(mark,".counts.summary"))
colnames(a)[7:18] = sub("bams.(.*_D.._.)_.*","\\1",colnames(a)[7:18])
colnames(b)[2:13] = sub("bams.(.*_D.._.)_.*","\\1",colnames(b)[2:13])
#total = colSums(b[which(b$Status %in% c("Assigned","Unassigned_NoFeatures","Unassigned_Ambiguity")),-1])
total = colSums(a[,-c(1:6)])

#b=read.table("../merged_peaks/H3K27me3_merged_peaks.over_input.bed")
counts = a[,-c(1:6)]
rpm = sweep(counts,2,total,'/')*1e6
rpkm = sweep(rpm,1,a$Length,'/')*1e3
rpkm.out = cbind(a[,1:6],rpkm)
write.table(rpkm.out,paste0(mark,".rpkm"),row.names=F,sep='\t',quote=F)
}


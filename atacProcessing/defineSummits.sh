#!/usr/bin/env Rscript
setwd("../../data/atac/peaks")

a=data.frame(fread("atac_merged_peaks.all_summits.txt"))

agg = aggregate(V6~V1+V2+V3+V4,a,median)
agg$V6 = floor(agg$V6)
agg$start = agg$V6-1000
agg$end = agg$V6+1000
write.table(agg[,c(1,6,7,4,5)],"atac_merged_peaks.summit.2k.txt",row.names=F,col.names=F,sep='\t',quote=F)
write.table(agg[,c(4,1,6,7,5)],"atac_merged_peaks.summit.2k.saf",row.names=F,col.names=F,sep='\t',quote=F)


a=read.delim("../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.overlap_stage.refined.txt")
d00 = a[which(a$D00.peak==1 & rowSums(a[,15:18])==1),]
gain = a[which(a$D00.peak==0 & rowSums(a[,15:18])>1),]


write.table(d00[,1:4],"CTCF.D00.bed",row.names=F,col.names=F,sep='\t',quote=F)



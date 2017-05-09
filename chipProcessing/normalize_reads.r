setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/counts")

a=data.frame(fread("H3K27me3.counts",skip=1))
b=read.table("../merged_peaks/H3K27me3_merged_peaks.filtered.bed")
counts = a[,-c(1:6)]
colnames(counts) = sub(".*(D.._.).*","\\1",colnames(counts))
rpm = sweep(counts,2,colSums(counts),'/')*1e6
rpkm = sweep(rpm,1,a$Length,'/')*1e3
rpkm.out = cbind(a[,1:6],rpkm)

rpkm.input = rpkm.out[which(a$Geneid %in% b$V4),]
rpkm.noninput = rpkm.out[which(!a$Geneid %in% b$V4),]

plot(rpkm[,1],rpkm[,2])
abline(0,1)
points(rpkm.input[,1],rpkm.input[,2],col='red')

write.table(rpkm.noninput, "H3K27me3.rpkm",row.names=F,sep='\t',quote=F)


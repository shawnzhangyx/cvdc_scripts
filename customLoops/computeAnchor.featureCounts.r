setwd("../../analysis/customLoops")

## histone marks
mark = "H3K27ac"
for (mark in c("H3K27ac","H3K27me3","H3K4me3","H3K4me1")){
print(mark)
anchor = read.delim(paste0("overlap_anchors_to_features/anchor.",mark,"_merged_peaks.txt"),header=F)
counts = data.frame(fread(paste0("../../data/chipseq/counts/",mark,".counts")))
colnames(counts)[-c(1:6)] = sub("bams.(.*D.._.).*.bam","\\1",colnames(counts)[-c(1:6)])
#colnames(anchor)[1:3] = c("Chr", "Start", "End")
sums = colSums(counts[,-c(1:6)])
counts[,-c(1:6)] = sweep(counts[,-c(1:6)],2,sums,'/')*1e6
m = merge(anchor,counts, by.x="V7",by.y="Geneid",all.x=T)
m[,c(13:24)][is.na(m[,c(13:24)])] = 0
agg = aggregate(.~V1+V2+V3, m[,c(2:4,13:24)],sum)
rep1 = agg[,seq(4,15,2)]
rep2 = agg[,seq(5,15,2)]
ave = cbind(agg[,1:3],(rep1+rep2)/2)
colnames(ave) = c("chr","start","end",paste0(mark,c("_D00","_D02","_D05","_D07","_D15","_D80")))

write.table(ave,paste0("overlap_anchors_to_features/anchor.",mark,".norm_counts.txt"),quote=F,sep='\t',row.names=F)
}

## CTCF. Needs to clean up. 
tf =  "CTCF"
anchor = read.delim(paste0("overlap_anchors_to_features/anchor.",tf,"_merged_peaks.txt"),header=F)
counts = data.frame(fread(paste0("../../data/tfChIPseq/counts/",tf,".counts")))
colnames(counts)[-c(1:6)] = sub("bam.(.*D..).*.bam","\\1",colnames(counts)[-c(1:6)])
sums = colSums(counts[,-c(1:6)])
counts[,-c(1:6)] = sweep(counts[,-c(1:6)],2,sums,'/')*1e6
m = merge(anchor,counts, by.x="V7",by.y="Geneid",all.x=T)
m[,c(13:20)][is.na(m[,c(13:20)])] = 0
agg = aggregate(.~V1+V2+V3, m[,c(2:4,13:20)],sum)
rep1 = agg[,seq(4,11,2)]
rep2 = agg[,seq(5,11,2)]
ave = cbind(agg[,1:3],(rep1+rep2)/2)

colnames(ave) = c("chr","start","end",paste0(tf,c("_D00","_D02","_D05","_D15")))
write.table(ave,paste0("overlap_anchors_to_features/anchor.",tf,".norm_counts.txt"),quote=F,sep='\t',row.names=F)


#mark = "ATAC"
## RNA-seq 
anchor = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)
rpkm = data.frame(fread("../../data/rnaseq/gene.rpkm.edger.txt"))
rpkm = rpkm[,c(1:15)]
m = merge(anchor,rpkm, by.x="V7",by.y="Geneid",all.x=T)
m[,c(13:24)][is.na(m[,c(13:24)])] = 0
agg = aggregate(.~V1+V2+V3, m[,c(2:4,13:24)],sum)
rep1 = agg[,4:9]
rep2 = agg[,10:15]
ave = cbind(agg[,1:3],(rep1+rep2)/2)
colnames(ave) = c("chr","start","end",paste0("RNAseq",c("_D00","_D02","_D05","_D07","_D15","_D80")))
write.table(ave,"overlap_anchors_to_features/anchor.rnaseq.norm_counts.txt",quote=F,sep='\t',row.names=F)


setwd("../../analysis/tads")

for (name in c("D00.unique","D00.pre","D00.pos")){

## histone marks
mark = "H3K27ac"
for (mark in c("H3K27ac","H3K27me3","H3K4me3","H3K4me1")){
print(mark)
tads = read.delim(paste0("overlap_tad_to_features/",name,".",mark,"_merged_peaks.txt"),header=F)
counts = data.frame(fread(paste0("../../data/chipseq/counts/",mark,".counts")))
colnames(counts)[-c(1:6)] = sub("bams.(.*D.._.).*.bam","\\1",colnames(counts)[-c(1:6)])
#colnames(tads)[1:3] = c("Chr", "Start", "End")
sums = colSums(counts[,-c(1:6)])
counts[,-c(1:6)] = sweep(counts[,-c(1:6)],2,sums,'/')*1e6
m = merge(tads,counts, by.x="V7",by.y="Geneid",all.x=T)
m[,c(13:24)][is.na(m[,c(13:24)])] = 0
agg = aggregate(.~V1+V2+V3, m[,c(2:4,13:24)],sum)
rep1 = agg[,seq(4,15,2)]
rep2 = agg[,seq(5,15,2)]
ave = cbind(agg[,1:3],(rep1+rep2)/2)
colnames(ave) = c("chr","start","end",paste0(mark,c("_D00","_D02","_D05","_D07","_D15","_D80")))

write.table(ave,paste0("overlap_tad_to_features/",name,".",mark,".norm_counts.txt"),quote=F,sep='\t',row.names=F)
}


#mark = "ATAC"
## RNA-seq 
tads = read.delim(paste0("overlap_tad_to_features/",name,".gene_tss.unique.txt"),header=F)
rpkm = data.frame(fread("../../data/rnaseq/gene.rpkm.edger.txt"))
rpkm = rpkm[,c(1:15)]
m = merge(tads,rpkm, by.x="V7",by.y="Geneid",all.x=T)
m[,c(13:24)][is.na(m[,c(13:24)])] = 0
agg = aggregate(.~V1+V2+V3, m[,c(2:4,13:24)],sum)
rep1 = agg[,4:9]
rep2 = agg[,10:15]
ave = cbind(agg[,1:3],(rep1+rep2)/2)
colnames(ave) = c("chr","start","end",paste0("RNAseq",c("_D00","_D02","_D05","_D07","_D15","_D80")))
write.table(ave,paste0("overlap_tad_to_features/",name,".rnaseq.norm_counts.txt"),quote=F,sep='\t',row.names=F)

}

setwd("../../analysis/tads/stage_specific_tads")

a=read.delim("../overlap_tad_to_features/D00.unique.gene_tss.unique.txt",header=F)
b=read.delim("../../../data/rnaseq/gene.rpkm.edger.txt")
d = b[which(b$Geneid %in% a$V7),]
d2 = d[,c(1,4:9)]
d2[,2:7] = (d2[,2:7]+d[,10:15])/2
d2 = d2[order(-d2$D00_1),]
#d0 = d[order(-d$exp),]
#out = d0[,c(1,25)]
colnames(d2) = c("Gene_Symbol","D00_RPKM","D02_RPKM","D05_RPKM","D07_RPKM","D15_RPKM","D80_RPKM")
write.csv(d2,"genes/D00_TADs_specific_genes.csv",row.names=F)

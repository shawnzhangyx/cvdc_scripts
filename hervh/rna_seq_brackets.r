setwd("../../data/rnaseq/")

a = read.delim("gene.rpkm.edger.txt")

a2 = data.frame(a$Geneid, (a$D00_1+a$D00_2)/2, a$logFC.D02.D00)
colnames(a2) = c("Geneid","rpkm","logFC.D2.D00")
a2 = a2[order(-a2$rpkm),]

#b = data.frame(fread("~/annotations/hg19/hg19.refGene.txt"))
#b= b[which(b$V13 %in% a2$Geneid),]
# remove redundant promoters. 
#b=b[!duplicated(b$V13),]

b=data.frame(fread("gencode.v19.transcriopts.tss1k.overlap_D00_H3K4me3_peaks.bed"))
#b=data.frame(fread("../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed"))
b=b[which(b$V4 %in% a2$Geneid),]
b = b[!duplicated(b$V4),]

a3 = cbind(b[match(a2$Geneid,b$V4),c(1,2,3)],a2)
a3 = a3[!is.na(a3$V1),]

write.table(a3, "../../analysis/hervh/D00.rna_seq.ranked_by_rpkm.bed",col.names=F, row.names=F,quote=F,sep="\t")




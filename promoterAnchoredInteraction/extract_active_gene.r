setwd("../../data/rnaseq")
a=read.delim("gene.rpkm.txt")
a$max = apply(a[,-1],1,max)

out = a[which(a$max>1),]
out = out[order(-out$max),]

write.table(out,"../../analysis/promoterAnchoredInteractions/genes_rpkm_max_gt1.txt",row.names=F,sep='\t',quote=F)

b = data.frame(fread("../annotation/gencode.v19.annotation.transcripts.tss1k.bed"))

out2 = b[which(b$V4 %in% out$Annotation.Divergence),]
out2$V2 = out2$V2+999
out2$V3 = out2$V3-1000
write.table(out2,"../../analysis/promoterAnchoredInteractions/genes_rpkm_max_gt1.tss.bed",row.names=F,col.names=F,sep='\t',quote=F)



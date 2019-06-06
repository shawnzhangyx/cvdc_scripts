setwd("../../analysis/hervh_ki")
a=read.delim("../../data/rnaseq_pipe/hg19/combined-chrM.counts",skip=1)
colnames(a) = sub("bam.(.*).nodup.bam","\\1",colnames(a))
rownames(a) = a$Geneid
# RLT_8 is an outlier
counts = a[,which(colnames(a) %in% paste0("RLT_",c(7,9:10)))]
counts = counts[,order( as.numeric( sub("RLT_(.*)","\\1",colnames(counts))))]

group = rep(c("HERV_KI1","HERV_KI2"),each=2)
group = group[-1]
design = model.matrix(~0+group)

library(edgeR)
y = DGEList(counts=counts,group=group)
#keep = which(rowSums(cpm(y)>1)>=2)
#y = y[keep,]

y = calcNormFactors(y)
y<-estimateCommonDisp(y, rowsum.filter=5)
y<-estimateGLMTagwiseDisp(y,design)
fit_tag<-glmFit(y,design)

lrt<-glmLRT(fit_tag,contrast=c(-1,1))
FDR_tag<- p.adjust(lrt$table$PValue, method="BH")
out = cbind(cpm(y),lrt$table,FDR_tag)
out = out[order(out$FDR_tag),]

write.table(out,"rna/HERV_KI1vsKI2.edger.txt",quote=F,sep="\t")


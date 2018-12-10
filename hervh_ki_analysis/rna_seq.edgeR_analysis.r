setwd("../../analysis/hervh_ki")

system("mkdir rna")

a=read.delim("../../data/rnaseq_pipe/hg19/combined-chrM.counts",skip=1)

colnames(a) = sub("bam.(.*).nodup.bam","\\1",colnames(a))
rownames(a) = a$Geneid
# RLT_8 is an outlier 
counts = a[,which(colnames(a) %in% paste0("RLT_",c(1:7,9:12)))]
counts = counts[,order( as.numeric( sub("RLT_(.*)","\\1",colnames(counts))))]

group = c(rep(c("ctrl-1","ctrl-2","ctrl-3"),each=2),rep(c("HERV_KI1","HERV_KI2","HERV_KI3"),each=2))
group = group[-8]
design = model.matrix(~0+group)

library(edgeR)
y = DGEList(counts=counts,group=group)
#keep = which(rowSums(cpm(y)>1)>=2)
#y = y[keep,]

y = calcNormFactors(y)
y<-estimateCommonDisp(y, rowsum.filter=5)
y<-estimateGLMTagwiseDisp(y,design)
fit_tag<-glmFit(y,design) 

lrt<-glmLRT(fit_tag,contrast=c(-1/3,-1/3,-1/3,1,0,0))
FDR_tag<- p.adjust(lrt$table$PValue, method="BH")
out = cbind(cpm(y),lrt$table,FDR_tag)
out = out[order(out$FDR_tag),]

write.table(out,"rna/HERV_KI1.edger.txt",quote=F,sep="\t")

lrt<-glmLRT(fit_tag,contrast=c(-1/3,-1/3,-1/3,0,1,0))
FDR_tag<- p.adjust(lrt$table$PValue, method="BH")
out = cbind(cpm(y),lrt$table,FDR_tag)
out = out[order(out$FDR_tag),]

write.table(out,"rna/HERV_KI2.edger.txt",quote=F,sep="\t")

lrt<-glmLRT(fit_tag,contrast=c(-1/3,-1/3,-1/3,0,0,1))
FDR_tag<- p.adjust(lrt$table$PValue, method="BH")
out = cbind(cpm(y),lrt$table,FDR_tag)
out = out[order(out$FDR_tag),]

write.table(out,"rna/HERV_KI3.edger.txt",quote=F,sep="\t")

lrt<-glmLRT(fit_tag,contrast=c(1,-1/2,-1/2,0,0,0))
FDR_tag<- p.adjust(lrt$table$PValue, method="BH")
out = cbind(cpm(y),lrt$table,FDR_tag)
out = out[order(out$FDR_tag),]

write.table(out,"rna/Ctrl_KI1.edger.txt",quote=F,sep="\t")


lrt<-glmLRT(fit_tag,contrast=c(-1/2,1,-1/2,0,0,0))
FDR_tag<- p.adjust(lrt$table$PValue, method="BH")
out = cbind(cpm(y),lrt$table,FDR_tag)
out = out[order(out$FDR_tag),]

write.table(out,"rna/Ctrl_KI2.edger.txt",quote=F,sep="\t")

lrt<-glmLRT(fit_tag,contrast=c(-1/2,-1/2,1,0,0,0))
FDR_tag<- p.adjust(lrt$table$PValue, method="BH")
out = cbind(cpm(y),lrt$table,FDR_tag)
out = out[order(out$FDR_tag),]

write.table(out,"rna/Ctrl_KI3.edger.txt",quote=F,sep="\t")

plotMDS(y)


require(edgeR)
setwd("../../data/enhancer_ko")
a=data.frame(fread("rnaseq_pipe/combined-chrM.counts"))
b=data.frame(fread("../rnaseq/rerun/combined-chrM.counts"))

counts = cbind(a[,-c(1:6)],b[,-c(1:3)])
group = c("WNT3-WT.1","WNT3-WT.2","WNT3-KO1.3","WNT3-KO1.4","WNT3-KO2.5","WNT3-KO2.6","MSX1-WT","MSX1-WT","N55","N55","N76","N76",sub("bam.RZY..._RNA_(D.*).nodup.bam","\\1",colnames(b[,-c(1:3)])))

design = model.matrix(~0+group)
y= DGEList(counts=counts,group=group)
keep = which(rowSums(cpm(y)>1)>=2)
y = y[keep,]
y =  calcNormFactors(y)


mds = plotMDS(y,label=group)

dat = data.frame(x=mds$x,y=mds$y,label=group)
require(ggrepel)

pdf("MDS_plot.pdf",width=4,height=4)
ggplot(dat) + geom_point( aes(x=x,y=y,color=label)) + 
  geom_label_repel(aes(x=x,y=y,color=label,label=label)) + 
  ggtitle("MDS Plot") + 
    theme( legend.position="none")
dev.off()

y<-estimateCommonDisp(y)
y<-estimateGLMTagwiseDisp(y,design)
fit_tag = glmFit(y,design)

### begin likelihood test. 
system("mkdir WT.vs.N55 WT.vs.N76")
# DLD1.vs.senp3
lrt = glmLRT(fit_tag, contrast = c(-1,0,1))
fdr = p.adjust(lrt$table$PValue,method="BH")
out = cbind(a[keep,1],cpm(y),lrt$table,fdr)
out = out[order(out$fdr),]
write.table(out,"DLD1.vs.senp3/DLD1.vs.senp3.edger.txt",row.names=F,sep='\t',quote=F)
write.table(out[,c(1,11,8)], "DLD1.vs.senp3/DLD1.vs.senp3.for_lrpath.txt",
  row.names=F,col.names=F,sep='\t',quote=F)
write.table(out[which(out$fdr<0.05 & out$logFC>0),1], "DLD1.vs.senp3/DLD1.vs.senp3.up.gene_symbol.txt",
  row.names=F,col.names=F,sep='\t',quote=F)
write.table(out[which(out$fdr<0.05 & out$logFC<0),1], "DLD1.vs.senp3/DLD1.vs.senp3.down.gene_symbol.txt",
  row.names=F,col.names=F,sep='\t',quote=F)

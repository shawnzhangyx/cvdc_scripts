setwd("../../analysis/tads/")
o=read.delim("combined_tads.uniq.counts.txt")
#colnames(o)[-c(1:3)]= sub(".*(D.*Rep.).*","\\1",colnames(o)[-c(1:3)])
#oe=read.delim("loops_merged.oe.txt")
#colnames(oe)[-c(1:3)]= sub(".*(D.*Rep.).*","\\1",colnames(oe)[-c(1:3)])
meta= read.delim("../../data/hic/meta/hic_meta.txt")
#o = o[!duplicated(o),]
require(edgeR)
counts = o[,c(4:15)]
rownames(counts) = paste(o$chr,o$x1,o$x2)
group = sub("(D..).*","\\1",colnames(counts))
design = model.matrix(~0+group)
lvls = levels(factor(group))
colnames(design) = lvls
len = length(lvls)
myContrasts = paste(lvls[2:len],lvls[1:(len-1)],sep='-')
contrast.matrix = eval(as.call(c(as.symbol("makeContrasts"),as.list(myContrasts),levels=list(design))))
counts[is.na(counts)]=0

y= DGEList(counts=counts,group=group)
y$samples$lib.size = meta$total_cis_pair
y =  calcNormFactors(y)
#write.table(cpm(y),paste0(type,".cpm.txt"),sep="\t",quote=F)
y<-estimateCommonDisp(y)
y<-estimateGLMTagwiseDisp(y,design)
fit_tag = glmFit(y,design)
lrt = glmLRT(fit_tag, contrast = contrast.matrix)
fdr = p.adjust(lrt$table$PValue,method="bonferroni")
out = cbind(o[,1:3],lrt$table,fdr)
write.table(out,"edgeR/tads_edgeR_test_allStage.txt",row.names=F,sep='\t',quote=F)
#write.table(out[order(out$fdr),],"edgeR/loops_edgeR_test_allStage.txt",row.names=F,sep='\t',quote=F)
# test = data.frame(c(1,1),c(2,2))
for (i in 1:length(myContrasts)){
  lrt = glmLRT(fit_tag, contrast = contrast.matrix[,i])
  fdr = p.adjust(lrt$table$PValue,method="bonferroni")
  out = cbind(o[,1:3],lrt$table,fdr)
  write.table(out,paste0("edgeR/tads_edgeR_test_",myContrasts[i],".txt"),row.names=F,sep='\t',quote=F)

  #write.table(out[order(out$fdr),],paste0("edgeR/loops_edgeR_test_",myContrasts[i],".txt"),row.names=F,sep='\t',quote=F)
}

write.table(cpm(y)*1000, "edgeR/tad_cpb.txt",sep="\t",quote=F)


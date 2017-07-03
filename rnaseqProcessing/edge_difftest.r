setwd("../../data/rnaseq/")
require(edgeR)
tab = read.delim("rerun/combined-chrM.counts")

counts = tab[,c(4:15)] 
rownames(counts)= tab$Geneid
colnames(counts) = paste(rep(c("D00","D02","D05","D07","D15","D80"),2), rep(c(1,2),each=6),sep='_')
group = sub(".*(D[0-9]+).*","\\1",colnames(counts))

design = model.matrix(~0+group)
lvls = levels(factor(group))
colnames(design) = lvls
len = length(lvls)
myContrasts = paste(lvls[2:len],lvls[1:(len-1)],sep='-')
contrast.matrix = eval(as.call(c(as.symbol("makeContrasts"),as.list(myContrasts),levels=list(design))))


y= DGEList(counts=counts,group=group)
# cpm > 1. 
keep = which(rowSums(cpm(y)>1)>=2)
y = y[keep,]
y =  calcNormFactors(y)
y<-estimateCommonDisp(y)
y<-estimateGLMTagwiseDisp(y,design)
fit_tag = glmFit(y,design)
lrt = glmLRT(fit_tag, contrast = contrast.matrix)
fdr = p.adjust(lrt$table$PValue,method="BH")
out = cbind(tab[keep,1:3],cpm(y),lrt$table,fdr)
out[,c(4:15)] = sweep(out[,c(4:15)],1,out$Length,'/')*1000

write.table(out,"gene.rpkm.edger.txt",row.names=F,sep='\t',quote=F)


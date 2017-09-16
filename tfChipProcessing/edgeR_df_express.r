setwd("../../data/tfChIPseq/")
require(edgeR)
mark="CTCF"

tab = read.delim(paste0("counts/",mark,".counts"),skip=1)
counts = tab[,c(7:14)]
rownames(counts)= tab$Geneid
colnames(counts) = paste(rep(c("D00","D02","D07","D15"),each=2), rep(c(1,2),4),sep='_')
group = sub(".*(D[0-9]+).*","\\1",colnames(counts))

design = model.matrix(~0+group)
lvls = levels(factor(group))
colnames(design) = lvls
len = length(lvls)
myContrasts = NULL
for (d02 in c("+D02","-D02")){
 for (d07 in c("+D07","-D07")){
  for (d15 in c("+D15","-D15")){
    myContrasts  = c(myContrasts, paste0("D00",d02,d07,d15))
    }}}
myContrasts = myContrasts[-1]
contrast.matrix = eval(as.call(c(as.symbol("makeContrasts"),as.list(myContrasts),levels=list(design))))
ratio = colSums(contrast.matrix==1)/colSums(contrast.matrix==-1)
contrast.matrix = sweep(contrast.matrix,2,ratio,'/')
contrast.matrix[contrast.matrix<0] = -1

y= DGEList(counts=counts,group=group)
# cpm > 1.
#keep = which(rowSums(cpm(y)>1)>=2)
#y = y[keep,]
y =  calcNormFactors(y)
y<-estimateCommonDisp(y)
y<-estimateGLMTagwiseDisp(y,design)
fit_tag = glmFit(y,design)
lrt = glmLRT(fit_tag, contrast = contrast.matrix)

qBH = p.adjust(lrt$table$PValue,method="BH")
out = cbind(tab,cpm(y),lrt$table,qBH)
out[,c(7:14)] = sweep(out[,c(7:14)],1,out$Length,'/')*1000

for (i in 1:length(myContrasts)){
  lrt = glmLRT(fit_tag, contrast = contrast.matrix[,i])
  out[,paste0("PValue.",myContrasts[i])] = lrt$table$PValue
  }

write.table(out,paste0("edger/",mark,".rpkm.fc.edger.txt"),row.names=F,sep='\t',quote=F)

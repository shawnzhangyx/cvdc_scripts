library(preprocessCore)

a = read.csv("boundaries/boundary.DI_delta.csv")

qtl = normalize.quantiles(as.matrix(a[,-1]))

#quantile normalize and transform negative to zero. 
a[,-1] = qtl
a[,-1][a[,-1]<0] = 0

b = a
b[,-1] = log2(b[,-1]+1)

# set the cutoff for tad boundaries. 
CUTOFF = log2(200)

# number of boundaries passing the cut-off. 
bd = b[,-1] > CUTOFF
bd.rep = bd[,seq(1,12,2)] * bd[,seq(2,12,2)]
numS = rowSums(bd.rep>0) 

#dynamic bins 
library(limma)
 
group = factor(substr(colnames(b)[-1],1,3))
design = model.matrix(~0+group)
colnames(design) = levels(group)

fit = lmFit(b[,-1], design)

myContrasts = c("D02-D00","D05-D02","D07-D05","D15-D07","D80-D15")
contrast.matrix = eval(as.call(c(as.symbol("makeContrasts"),as.list(myContrasts),levels=list(design))))

fit2 = contrasts.fit(fit, contrast.matrix)
fit4 = eBayes(fit2,trend=F)
##
fdr = apply(fit4$p.value,2,p.adjust,method="BH")

out = cbind(a,numS,fdr)
#remove boundarie that are constant
out2 = out[which(out$numS >0 & out$numS<5),]
# keep boundaries that significantly change. 
pval.min = apply(out2[,15:19],1,min)
out3 = out2[which(pval.min < 0.01),]

melted = melt(out3[,1:13])
ggplot(melted) + geom_tile(aes(x=variable,y=name,fill=log2(value+1)))

#out2 = out2[order(out2$"D02-D00"),]

library(gplots)

heatmap.2(log2(as.matrix(out3[,2:13])+1),Colv=FALSE,
cexRow=1,cexCol=1,notecol='black',margins=c(10,10),tracecol=F)


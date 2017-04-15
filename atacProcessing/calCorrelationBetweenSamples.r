setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/counts")
counts = data.frame(fread("atac.allSample.read.counts",skip=1))
summary = read.delim("atac.allSample.read.counts.summary",row.names=1)

pdf("atac_mapping_summary.pdf")
# total number of reads
total = colSums(summary)
qplot(y=colnames(summary),x=total,xlim=c(0,max(total)))
# mapping ratio
map.ratio = 1- as.numeric(summary[5,])/total
qplot(y=colnames(summary),x=map.ratio,xlim=c(0,1))
# assign ratio
assign.ratio = as.numeric(summary[1,])/total
qplot(y=colnames(summary),x=assign.ratio,xlim=c(0,1))
# total assigned/ total mapped
assign.map.ratio = as.numeric(summary[1,])/(total-as.numeric(summary[5,]))
qplot(y=colnames(summary),x=assign.map.ratio,xlim=c(0,1))
dev.off()

## make PCA plot
norm = counts[,-c(1:6)]
norm = sweep(norm,2,colSums(norm),'/')


norm.log = log2(norm)

jpeg("atac.scatter.plot.jpg",height=2048,width=2048)
par(mfrow=c(14,14),mar=c(5,5,0,0))
for (i in 1:14){
  for (j in 1:14){
  print(c(i,j))

  plot(norm.log[,i],norm.log[,j],ylab=colnames(norm)[i],xlab=colnames(norm)[j])
  } 
}

dev.off()


## calculate sample correlation
cor.matrix =matrix(0,nrow=14,ncol=14)
rownames(cor.matrix) = colnames(cor.matrix) = colnames(norm)
spr.matrix = matrix(0,nrow=14,ncol=14)
rownames(spr.matrix) = colnames(spr.matrix) = colnames(norm)

for (i in 1:14){
  for (j in 1:14){
    cor.matrix[i,j] = cor.test(norm[,i], norm[,j],method='pearson')$estimate
    spr.matrix[i,j] = cor.test(norm[,i], norm[,j],method='spearman')$estimate
    }
  }

## PCA
pdf("atac.correlation.pdf")
pca = prcomp(t(norm))
plot(pca$x,type='n',xlim=c(-0.05,0.05))
text(pca$x,labels=colnames(counts)[-c(1:6)])
require(gplots)
heatmap.2(cor.matrix,marings=c(15,15))
heatmap.2(spr.matrix,margins=c(15,15))
dev.off()


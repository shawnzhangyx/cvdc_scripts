setwd("../../analysis/hiccup_loops/")
library(cluster)
library(fpc)

d = read.delim("loops.cpb.logFC.edger.dynamic.txt")

cpb = d[,c(2:13)]
norm = sweep(cpb,1, apply(cpb,1,function(x)sqrt(sum(x**2))),'/')

pca = prcomp(norm)
#plot(pca$x[,1],pca$x[,2])
pcaOut = data.frame(pca$x[,1],pca$x[,2])
colnames(pcaOut) = c("PC1","PC2")
ggplot(pcaOut, aes(x=PC1,y=PC2)) + geom_point()+ geom_density_2d()

#pca = prcomp(t(norm))
#plot(pca$x[,1],pca$x[,2],type='n')
#text(pca$x[,1],pca$x[,2],colnames(cpb))

pdf("figures/dynamic_loops.k_2to10.pdf")
for(k in 2:10){
print(k)
km = kmeans(norm,centers=k)
#plotcluster(norm, km$cluster)
require(gplots)
heatmap.2(km$centers,Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("lightyellow","red"))
)
}
dev.off()


### K-means clustering with K = 6. 

set.seed(1)
km = kmeans(norm,centers=6)
#stage = km$centers %*% rep(1:6,each=2)/6
c1 = 1:6
c2 = c(4,3,5,1,2,6)
km$centers = km$centers[c2,]
rownames(km$centers) = 1:6
km$cluster = order(c2)[km$cluster]
norm.o = norm[order(-km$cluster),]
rownames(norm.o) = 1:nrow(norm.o)
melted =melt(as.matrix(norm.o))
size = rev(table(km$cluster))
inc = 0
for (i in 1:length(size))inc[i+1] = inc[i]+ size[i]

pdf("figures/dynamic_loops.kmeans_K6.pdf")
heatmap.2(km$centers,Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("lightyellow","red"))
)

ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile() + 
  scale_fill_gradient2(high="red",mid="lightyellow") + 
  geom_hline(yintercept=inc)
dev.off()

d$cluster = km$cluster

write.table(d,"loops.cpb.logFC.edger.dynamic.cluster.txt",quote=F,sep='\t')


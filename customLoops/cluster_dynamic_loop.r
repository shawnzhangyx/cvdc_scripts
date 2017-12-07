setwd("../../analysis/customLoops/")
library(cluster)
library(fpc)

d = read.delim("loops/loops.cpb.logFC.edger.dynamic.txt")

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


### K-means clustering with K = 5. 

set.seed(1)
km = kmeans(norm,centers=5)
#stage = km$centers %*% rep(1:6,each=2)/6
c1 = 1:5
c2 = c(3,4,1,2,5)
km$centers = km$centers[c2,]
rownames(km$centers) = 1:5
km$cluster = order(c2)[km$cluster]
norm.o = norm[order(-km$cluster),]
rownames(norm.o) = 1:nrow(norm.o)
norm.o = (norm.o[,seq(1,12,2)]+norm.o[,seq(2,12,2)])/2
colnames(norm.o) = substr(colnames(norm.o),1,3)
melted =melt(as.matrix(norm.o))
size = rev(table(km$cluster))
inc = 0
for (i in 1:length(size))inc[i+1] = inc[i]+ size[i]

pdf("figures/dynamic_loops.kmeans_K5.pdf",width=4,height=4)
ggplot() + geom_tile(data=melted,aes(x=Var2,y=Var1,fill=value)) + 
  scale_fill_gradientn(colors=c("white","red","red"),values=c(0,0.7,1),name="") +
  geom_segment(aes(x=0.5,y=inc,xend=6.5,yend=inc),linetype="dashed") + 
  geom_rect(aes(xmin=0.5,xmax=6.5,ymin=0,ymax=inc[length(inc)]),size=1,fill=NA,color='black') + 
  scale_y_continuous(breaks=inc[-1]-200,labels=size) + 
  theme_minimal() +
  xlab("") + ylab("") + 
  theme( axis.text.x = element_text(angle = 90, hjust = 1),
#         axis.text.y = element_text(breaks=inc[-1],values=size),
  legend.justification = c("right", "top")
  )
dev.off()

d$cluster = km$cluster
write.table(d,"loops/loops.cpb.logFC.edger.dynamic.cluster.txt",quote=F,sep='\t')

all = read.delim("loops/loops.cpb.logFC.edger.final.txt")
all$cluster=0
all$cluster[match(d$name,all$name)] = d$cluster
write.table(all,"loops/loops.cpb.logFC.edger.final.cluster.txt",quote=F,sep='\t')


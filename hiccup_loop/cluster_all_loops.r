setwd("../../analysis/hiccup_loops/edgeR")

cpb= read.delim("loops_cpb.txt")

norm.f = sapply(1:nrow(cpb),function(x){ sqrt(sum( cpb[x,]**2))})

norm = sweep(cpb,1,norm.f,'/')

#dis = dist(norm)
cova = cov(t(norm))
dis = as.dist(max(cova)-cova)

hc = hclust(dis,method="average")

norm.o = norm[hc$order,]
#norm.o = sweep(cpms.o, 1, apply(cpms.o,1,function(x){sqrt(sum(x**2))}),'/')
melted = melt(as.matrix(norm.o))

#pdf("../clusters/cpb.norm.hc.clusters.pdf",height=20,width=15)
png("../clusters/cpb.norm.hc.dendrogram.png",height=1000,width=500)
plot(as.dendrogram(hc),horiz=T)
dev.off()
png("../clusters/cpb.norm.hc.heatmap.png",height=1000,width=500)
ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white") +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )

dev.off()

K=15
km = kmeans(norm,K,100,nstart=25)
norm.km = norm[order(km$cluster),]
melted = melt(as.matrix(norm.km))
png("../clusters/cpb.norm.km.heatmap.png",height=1000,width=500)
ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white") +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )

dev.off()



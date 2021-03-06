setwd("../../data/rnaseq/")
a=read.delim("gene.rpkm.edger.txt")
#cpm = a[,4:15]
cpm = a[,c(4,10,5,11,6,12,7,13,8,14,9,15)]
rmax = apply(cpm,1,max)
ecpm = cpm[which(rmax>10),]
ecpm = sweep(ecpm,1, apply(ecpm,1, function(vec){ sqrt(sum(vec**2))}),'/')
set.seed(1)
km = kmeans(ecpm,6)

c1 = 1:6
c2 = c(5,6,2,4,3,1)
#c2 = c(1,3,4,2,6,5)
km$centers = km$centers[c2,]
rownames(km$centers) = 1:6
km$cluster = order(c2)[km$cluster]



center = melt(km$centers)
ecpm.o = ecpm[order(km$cluster),]
rownames(ecpm.o) = 1:nrow(ecpm.o)
melted = melt(as.matrix(ecpm.o))

num = table(km$cluster)
inc =0
for (i in 1:length(num)) { inc[i+1] = inc[i] + num[i] }

pdf("gene_expression_cluster.pdf")
ggplot(center, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white")
ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() + 
  scale_fill_gradient2(high="red",mid="white") +
  geom_hline(yintercept=inc)
dev.off()

out = a[which(rmax>10),]
out$cluster = km$cluster

write.table(out, "gene.rpkm.cluster.txt",row.names=F,sep='\t',quote=F)
table(out$cluster)
# 1    2    3    4    5    6
# 955 2455  546 3422  292 1114
for (clu in 1:6){
  write.table(out[which(out$cluster==clu),1],paste0("clusters/cluster.",clu,".gene.txt"),row.names=F,col.names=F,quote=F)
  }


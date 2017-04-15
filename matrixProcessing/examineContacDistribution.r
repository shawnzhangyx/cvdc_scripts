etwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/dixonMatrix")
a = data.frame(fread("D00_HiC_Rep1.chr14.norm.txt"))
#a = round(a)

rsum = rowSums(a)
INT = 500
p.list = list()
for (i in (INT+1):(dim(a)[1]-INT)){
  print(i)
  c1 = a[i,c(i-INT):(i+INT)]
  if (rsum[i] != 0){
  p.list[[length(p.list)+1]] = as.numeric(c1)
  }
}
p.mat = do.call(rbind, p.list)

library(lattice)
levelplot(p.mat)

SLICE = 10
p.slice = p.mat[,(501-SLICE):(501+SLICE)]
km = kmeans(p.slice,20,100,nstart=10)

p.ordered = p.slice[order(km$cluster),]

melted = melt(p.ordered)
ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value)) + scale_fill_gradient2(low="white",high="red", limits=c(0,200))

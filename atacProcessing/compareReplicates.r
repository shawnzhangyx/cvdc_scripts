setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/counts")
counts = data.frame(fread("atac.allSample.read.counts",skip=1))
summary = read.delim("atac.allSample.read.counts.summary",row.names=1)

dat = counts[,-c(1:6)]
total1 = colSums(dat)
total2 = as.numeric(colSums(summary)-summary[5,])
ratio = total2/total1
qplot(x=ratio,y=colnames(dat))

norm1 = sweep(dat+0.01,2,total1,'/')*10**6
norm2 = sweep(dat+0.01,2,total2,'/')*10**6

i=1
j=14
for (j in 2:14){
print(j)
png(paste0("norm_method_comp",j,".png"))
p1=qplot(norm1[,i],norm1[,j],xlim=c(0,1000),ylim=c(0,1000),xlab=colnames(dat)[i],ylab=colnames(dat)[j]) + geom_abline(intercept=0,slope=1,col='red')
p2=qplot(norm2[,i],norm2[,j],xlim=c(0,300),ylim=c(0,300),xlab=colnames(dat)[i],ylab=colnames(dat)[j]) + geom_abline(intercept=0,slope=1,col='red')

require(gridExtra)
grid.arrange(p1,p2)
dev.off()
}

ratio1.list = NULL
ratio2.list = NULL

norm1.quantile = quantile(rowSums(norm1),c(0.2,0.8))
norm1.trim = norm1[which(rowSums(norm1) > norm1.quantile[1] & rowSums(norm1) < norm1.quantile[2]),]
norm2.quantile = quantile(rowSums(norm2),c(0.2,0.8))
norm2.trim = norm2[which(rowSums(norm2) > norm2.quantile[1] & rowSums(norm2) < norm2.quantile[2]),]


i=1
j=2
for (i in 1:14){
  for (j in 1:14){
print(c(i,j))
ratio1 = log2(norm1.trim[,i]/norm1.trim[,j]) #* sqrt(norm1.trim[,i]+norm1.trim[,j])
ratio2 = log2(norm2.trim[,i]/norm2.trim[,j]) #* sqrt(norm2.trim[,i]+norm2.trim[,j])

#summary(ratio1)
#summary(ratio2)

ratio1.list[length(ratio1.list)+1] = sum(abs(ratio1))
ratio2.list[length(ratio2.list)+1] = sum(abs(ratio2))
}
}
plot(ratio1.list, ratio2.list)
abline(0,1)
# the higher the ratio, the worse the results. 
ratio.out = matrix(ratio1.list/ratio2.list, nrow=14)
library(lattice)
levelplot(ratio.out)


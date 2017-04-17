setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/tads")
a=read.delim("insulation_data/combined.matrix",header=F)

dat = a[,-c(1:3)]
names = sub(".bedgraph","",list.files(pattern="bedgraph",path="insulation_data"))


mat = matrix(0,nrow=ncol(dat),ncol=ncol(dat))

for (i in 1:(ncol(dat)-1)){
   for (j in i:ncol(dat)){
   print(c(i,j))
   mat[j,i] = cor.test(dat[,i],dat[,j],method="spearman")$estimate
   }
   }

rownames(mat) = colnames(mat) = names
dist = as.dist(1-mat)

#hclust(dist)

mat.h = mat+t(mat)
for (i in 1:nrow(mat)) mat.h[i,i] = 1

library(gplots)

pdf("insulation_data/insulation_score_clustering.pdf")
plot(hclust(dist))
heatmap.2(mat.h,Colv=FALSE,Rowv=FALSE,dendrogram="none",
    cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
    col=colorRampPalette(c("lightyellow","red"))
      )
dev.off()



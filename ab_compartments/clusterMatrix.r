setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/ab_compartments")
a=read.delim("pc1_data/combined.matrix",header=F)

mat = a[,-c(1:3)]
diff =  mat[,ncol(mat)]-mat[,1]
top500_increase = a[order(-diff),][1:500,]
top500_decrease = a[order(diff),][1:500,]

write.table(top500_increase,"clusters/top500_increase.bed",row.names=F,col.names=F,quote=F,sep='\t')
write.table(top500_decrease,"clusters/top500_decrease.bed",row.names=F,col.names=F,quote=F,sep='\t')


mmax = apply(mat,1,max)
mmin = apply(mat,1,min)
range = mmax-mmin

mvar = apply(mat,1,var)
## select the top 10% variance. 
mat_topv = mat[which(mvar> quantile(mvar,0.9)),]

mat_out = a[which(mvar> quantile(mvar,0.9)),]
#name = paste(mat_out$V1,mat_out$V2,mat_out$V3)
#mat_out = cbind(name,mat_topv)
write.table(mat_out,"clusters/matrix_for_clustering.bed",row.names=F,col.names=F,quote=F,sep='\t')

colnames(mat_topv) = c("D00","D02","D05","D07","D15","D80")
library(gplots)
#test = mat_topv[1:100,]
#heatmap.2(as.matrix(test),cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,col=colorRampPalette(c("blue","red")))
hmap = heatmap.2(as.matrix(mat_topv),cexRow=1,cexCol=1,Colv=F,notecol='black',margins=c(5,5),tracecol=F,col=colorRampPalette(c("blue","red")),
#distfun = function(x) as.dist((1-cor(t(x)))/2),
hclust=function(x) hclust(x,method="average"))
out = t(hmap$carpet)

pdf("clusters/cluster_heatmap.pdf")
heatmap.2(as.matrix(mat_topv),cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,col=colorRampPalette(c("blue","red")),
#distfun = function(x) as.dist((1-cor(t(x)))/2),
hclust=function(x) hclust(x,method="average"))

heatmap.2(as.matrix(mat_topv),cexRow=1,cexCol=1,Colv=F,notecol='black',margins=c(5,5),tracecol=F,col=colorRampPalette(c("blue","red")),
hclust=function(x) hclust(x,method="average"))
dev.off()




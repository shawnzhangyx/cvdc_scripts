a=data.frame(fread("chr1_combined.cleaned.txt"))

library(preprocessCore)
qtl = normalize.quantiles(as.matrix(a[,3:14]))
b= a
b[,3:14] = qtl
out = b
out[,3:14] = format(out[,3:14],digits=2)
write.table(out,"chr1_combined.quantile.txt", col.names=F,row.names=F,sep='\t',quote=F)

## check if the distribution has changed. 
a$dist = a$x2-a$x1
agg = aggregate(.~dist,a,FUN=sum)
write.table(agg[,c(1,4:15)], "chr1.dist.count",col.names=F,row.names=F)
b$dist = b$x2-b$x1
agg2 = aggregate(.~dist,b,FUN=sum)
write.table(agg2[,c(1,4:15)], "chr1.quantile.dist.count",col.names=F,row.names=F)

agg[,4:15] = sweep(agg[,4:15],2,colSums(agg[,4:15]),'/')
mat1 = melt(agg[,-c(2,3)],id.var="dist")

ggplot(subset(mat1,dist>5e4 & dist <6e7),
  aes(x=variable, y=log2(dist),fill=value)) +
  stat_bin_2d()# + #scale_y_log10() +

ggplot(mat1, aes(x=dist,color=substr(variable,1,3),y=value)) + geom_line() +
  scale_y_log10()
ggplot(subset(mat1,dist>5e4), aes(x=dist,color=substr(variable,1,3),y=value)) +
  geom_point() + geom_smooth()+
    xlim(0,2e6) #+ scale_y_log10()


agg2[,4:15] = sweep(agg2[,4:15],2,colSums(agg2[,4:15]),'/')
mat2 = melt(agg2[,-c(2,3)],id.var="dist")

ggplot(mat2, aes(x=dist,color=substr(variable,1,3),y=value)) + geom_line() +
  scale_y_log10()
ggplot(subset(mat2,dist>5e4), aes(x=dist,color=substr(variable,1,3),y=value)) +
  geom_point() + geom_smooth()+
      xlim(0,1e6) #+ scale_y_log10()




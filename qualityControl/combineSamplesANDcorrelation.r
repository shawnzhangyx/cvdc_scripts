setwd("../../analysis/qualityControl/contactMatrix_lt5m")

files = list.files(pattern="txt")

dlist = list()
for (i in seq(1,12,2) ){
  print(files[i:(i+1)])
  data1 = data.frame(fread(files[i]))
  data2 = data.frame(fread(files[i+1]))

  data1$name = paste(data1$V1,data1$V2,data1$V3)
  data2$name = paste(data2$V1,data2$V2,data2$V3)
  data1 = data1[,c(5,4)]
  data2 = data2[,c(5,4)]
  out= merge(data1,data2,by="name")
  dlist[[length(dlist)+1]] = out
  }

pdf("correlation_plot.pdf",height=5,width=5)
for (i in 1:6){
  out = dlist[[i]]
  cor = cor.test(out[,2],out[,3],method="spearman")
    smoothScatter(log2(out[,2]),log2(out[,3]), main=paste("Cor =",format(cor$estimate,digits=2)),
    xlab = sub("_100000.txt","",files[i*2-1]),
    ylab = sub("_100000.txt","",files[i*2])
    )
  }
dev.off()


for (i in seq(1,12) ){
  print(i)
  data = data.frame(fread(files[i]))
  data$name = paste(data$V1,data$V2,data$V3)
  data$wid = data$V3-data$V2

  if ( i == 1){
  data = data[,c(6,5,4)]
  out = data
  } else {
  data = data[,c(5,4)]
  out = merge(out,data,by="name")
  }
  }

mat = matrix(0,nrow=12,ncol=12)
for (i in 1:11){
  for (j in (i+1):12){
   print(c(i,j))
   mat[i,j] = cor.test(out[,i+2], out[,j+2],method="spearman")$estimate
   }
   }
rownames(mat) = colnames(mat) = sub("_100000.txt","",files)
dist = as.dist(1-t(mat))
pdf("correlation_distance_clustering.pdf")
plot(hclust(dist))
dev.off()

## ploting the heatmap
library(gplots)
mat.h = mat+t(mat)
for ( x in 1:nrow(mat.h) ) { mat.h[x,x] = 1}
pdf("correlation_heatmap.pdf")
heatmap.2(mat.h,Colv=FALSE,Rowv=FALSE, margins=c(10,10),notecol='black',tracecol=F,
  col=colorRampPalette(c("lightyellow","red"))
  )
dev.off()


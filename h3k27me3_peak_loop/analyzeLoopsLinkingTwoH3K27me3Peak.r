setwd("../../analysis/h3k27me3_loop/k27Tok27LoopValuesAndCorrelation")

loop.k27 = read.delim("k27.loop.k27.txt",stringsAsFactors=F)
loop = read.delim("loops.mat.txt",header=F,stringsAsFactors=F)
k27 = read.delim("k27.rpkm.txt",stringsAsFactors=F)
loop = loop[!apply(loop[,-c(1:3)],1, function(x){ any(is.na(x))}),]

#cor.dist = as.dist(1-cor(t(k27[,-c(1:6)])))
#hc = hclust(cor.dist)
#k27.or = k27[hc$order,]
#k27.or$Geneid = factor(k27.or$Geneid, levels=k27.or$Geneid)
#melted = melt(k27.or[,-c(2:6)])
#ggplot(melted,aes(x=variable,y=Geneid,fill=value)) + geom_tile()+
#scale_fill_gradient2(mid='white',high='red')
loop.name = paste0("chr",loop$V1," ", loop$V2," ",loop$V3)
loop.k27 = loop.k27[loop.k27$name %in% loop.name,]

loop.k27.wname = loop.k27[,c(1,2,9)]
loop.k27.wname = cbind(loop.k27.wname, loop[match(loop.k27.wname$name, loop.name),-c(1:3)])
loop.k27.m  = loop.k27.wname[,-1]
## combine the loop contacts for the same K27 peak pair. 
loop.k27.m = aggregate(.~V4.x+V4.y,loop.k27.m,sum)

k27.1m = k27[match(loop.k27.m$V4.x, k27$Geneid),-c(1:6)]
k27.2m = k27[match(loop.k27.m$V4.y, k27$Geneid),-c(1:6)]

loop.k27.max = apply(loop.k27.m[,-c(1,2)],1,function(x){sqrt(sum(x**2))})
k27.1m.max = apply(k27.1m,1,function(x){sqrt(sum(x**2))})
k27.2m.max = apply(k27.2m,1,function(x){sqrt(sum(x**2))})



loop.k27.norm = sweep(loop.k27.m[,-c(1,2)],1,loop.k27.max,'/')
k27.1norm = sweep(k27.1m, 1, k27.1m.max, '/')
k27.2norm = sweep(k27.2m, 1, k27.2m.max, '/')

#hc = hclust(dist(loop.k27.norm),method="average")
hc = hclust(dist(1-cor(t(k27.1norm))),method="average")
#
loop.k27.wname[hc$order,][170:180,]
loop.k27.or = loop.k27.norm[hc$order,]
k27.1or = k27.1norm[hc$order,]
k27.2or = k27.2norm[hc$order,]
loop.max.or = log2(loop.k27.max[hc$order])
#
#km = kmeans(loop.k27.norm,5, iter.max=10, nstart=2)
#loop.k27.or = loop.k27.norm[order(km$cluster),]
#k27.1or = k27.1norm[order(km$cluster),]
#k27.2or = k27.2norm[order(km$cluster),]

pdf("loopsAndK27rpkm.hc_by_k27.pdf",height=20,width=8)
require(gplots)
heatmap.2(as.matrix(loop.k27.or), Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("white","red"))
#col=colorRampPalette(c("blue","white","red","red"))
)
heatmap.2(as.matrix(k27.1or), Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("white","red"))
)
heatmap.2(as.matrix(k27.2or), Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("white","red"))
)
heatmap.2(as.matrix(cbind(loop.max.or,loop.max.or)), Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("white","red"))
)

dev.off()


#loop.k27.or = cbind(1:nrow(loop.k27.norm),loop.k27.norm[hc$order,])



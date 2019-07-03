setwd("../../analysis/hiccup_loops")
loop = read.delim("replicated_loops.cpb.logFC.edger.nondynamic.txt")
## leave cluster D02
#a = read.delim("anchors/anchors.sorted.by.cluster_feature.txt")
a = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
colnames(a)[1:3] = c("chr","start","end")
lists = list()
lists[["anchor"]] = a[,c(1:3)]
for (feature in c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","rnaseq")){
  data = read.delim(paste0("overlap_anchors_to_features/anchor.",
    feature,".norm_counts.txt"))
#  data[,c(4:9)] = sweep(data[,c(4:9)],1,apply(data[,c(4:9)],1,max),'/')
  lists[[feature]] = data
    }
feature = read.delim("overlap_anchors_to_features/anchor.all_features.txt")
lists[["feature"]] = feature
m = Reduce(function(...)merge(..., by=c("chr","start","end"),sort=F),lists)


loop.essential = cbind(loop$name,loop[,seq(2,13,2)]+loop[,seq(3,13,2)])
d2 = loop.essential
colnames(d2)[1] = "name"
d2$chr = sub("(.*) (.*) (.*)","\\1",d2$name) 
d2$x1 = as.numeric(sub("(.*) (.*) (.*)","\\2",d2$name))-10000
d2$y1 = as.numeric(sub("(.*) (.*) (.*)","\\3",d2$name))-10000

a1 = merge(d2,m, by.x=c("chr","x1"),by.y=c("chr","start"),sort=F)
a2 = merge(d2,m, by.x=c("chr","y1"),by.y=c("chr","start"),sort=F)
a1 = a1[match(d2$name, a1$name),]
a2 = a2[match(d2$name, a2$name),]
k4me3a1 = apply(a1[,c(12:17)],1,max)
k4me3a2 = apply(a2[,c(12:17)],1,max)

k27me3a1 = apply(a1[,c(18:23)],1,max)
k27me3a2 = apply(a2[,c(18:23)],1,max)

k27me3.cor = sapply(1:nrow(a1), function(i){ 
  cor(as.numeric(a1[i,c(18:23)]),as.numeric(a2[i,c(18:13)])) })

k27ac.cor = sapply(1:nrow(a1), function(i){
  cor(as.numeric(a1[i,c(24:29)]),as.numeric(a2[i,c(24:29)])) })


k27aca1 = apply(a1[,c(24:29)],1,max)
k27aca2 = apply(a2[,c(24:29)],1,max)

summary(k4me3a1)
summary(k27me3a1)
summary(k27aca1)

### sort by an defined order. 
od = order(a1$H3K4me3<1, a2$H3K4me3<1,a1$H3K27me3<1, a2$H3K27me3<1, -k4me3a1,-k4me3a2)
a1 = a1[od,]
a2 = a2[od,]

mat1 = a1[,-c(1,2,3,10,11,42:48)]
#mat1 = mat1[order(-k4me3a1,-k27aca1),]
for (i in seq(1,31,6)){
mat1[,i:(i+5)] = sweep(mat1[,i:(i+5)],1,apply(mat1[,i:(i+5)],1,max),'/')
}
mat1[is.na(mat1)] = 0
#mat1[,1:6] = sweep(mat1[,1:6],1,apply(mat1[,1:6],1,max),'/')
mat2 = a2[,-c(1,2,3,10,11,42:48)]
#mat2 = mat2[order(-k4me3a1,-k27aca1),]
for (i in seq(1,31,6)){
mat2[,i:(i+5)] = sweep(mat2[,i:(i+5)],1,apply(mat2[,i:(i+5)],1,max),'/')
}
mat2[is.na(mat2)] = 0


require(gplots)
pdf(paste0("figures/cluster",clu, ".heatmap.pdf"))
heatmap.2(as.matrix(mat1),Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
key=F)

heatmap.2(as.matrix(mat2),Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
key=F
)
dev.off()

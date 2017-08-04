setwd("../../analysis/hiccup_loops/")
options(scipen=99)
##table 1: loops
loops = read.delim("replicated_loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
## table 2: anchors2tss
anchors = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)
## table 3: gene rpkm 
feature = read.delim("../../data/rnaseq/gene.rpkm.edger.txt")
feature$fdr = p.adjust(feature$PValue)

##
loops$anchor1 = paste(loops$chr,loops$x1)
loops$anchor2 = paste(loops$chr,loops$y1)
loops.red = loops[,c(1,32:34)]
anchors$name = paste(anchors$V1,anchors$V2+10000)
## merge loops with anchors. 
anchors1 = merge(loops.red,anchors,by.x="anchor1",by.y="name",all.x=T)[,c(1,2,3,11)]
anchors2 = merge(loops.red,anchors,by.x="anchor2",by.y="name",all.x=T)[,c(1,2,3,11)]

anchors1.rpkm = merge(anchors1,feature, by.x="V7",by.y="Geneid",all.x=T)
anchors2.rpkm = merge(anchors2,feature, by.x="V7",by.y="Geneid",all.x=T)
## rpkm > 1 in at least 2 samples. 
anchors1.rpkm$expressed = apply(anchors1.rpkm[,7:18],1,function(x){length(which(x>1))>2})
anchors2.rpkm$expressed = apply(anchors2.rpkm[,7:18],1,function(x){length(which(x>1))>2})
anchors1.rpkm$df = ifelse(anchors1.rpkm$fdr<0.05,TRUE,FALSE)
anchors2.rpkm$df = ifelse(anchors2.rpkm$fdr<0.05,TRUE,FALSE)


## percent of anchor contain TSS
a1.unique = aggregate(V7~name+cluster,anchors1,FUN=function(vec){ sum(vec!=".")>0})
a2.unique = aggregate(V7~name+cluster,anchors2,FUN=function(vec){ sum(vec!=".")>0})

ggplot(a1.unique, aes(x=cluster,fill=V7))+ 
  geom_bar(position="fill",stat="count") + ggtitle("Anchor1 percent overlap TSS")
ggplot(a2.unique, aes(x=cluster,fill=V7))+
  geom_bar(position="fill",stat="count") + ggtitle("Anchor2 percent overlap TSS")

a1.expressed = aggregate(expressed~name+cluster,anchors1.rpkm,
  FUN=function(vec){ sum(vec!=FALSE)>0})
a2.expressed = aggregate(expressed~name+cluster,anchors2.rpkm,
  FUN=function(vec){ sum(vec!=FALSE)>0})

ggplot(a1.expressed, aes(x=cluster,fill=expressed))+
  geom_bar(position="fill",stat="count") + ggtitle("Anchor1 percent overlap TSS expressed")
ggplot(a2.expressed, aes(x=cluster,fill=expressed))+
  geom_bar(position="fill",stat="count") + ggtitle("Anchor2 percent overlap TSS expressed")



## leave only the anchors with differential expressed gene for plotting
anchors1.expressed = anchors1.rpkm[which(anchors1.rpkm$df==TRUE),] 
anchors1.expressed = anchors1.expressed[order(-anchors1.expressed$cluster),]
num = rev(table(anchors1.expressed$cluster))
inc = 0
for(i in 1:length(num)) inc[i+1] = inc[i] + num[i]

mat1 = as.matrix(anchors1.expressed[,c(7:18)])
mat1 = mat1[,c(1,7,2,8,3,9,4,10,5,11,6,12)]
mat1 = log2(sweep(mat1+1e-6,1,apply(mat1,1,mean),"/"))
rownames(mat1) = 1:nrow(mat1)
a1.melt= melt(mat1)

#a1.melt = melt(as.matrix(anchors1.rpkm[order(anchors1.rpkm$cluster),][,-c(1:4)]))

ggplot(a1.melt,aes(x=Var2,y=Var1,fill=value)) + geom_tile() + 
#  scale_fill_gradient2(high="red",mid="white",low="white") +
  scale_fill_gradientn(colours = c("darkblue", "white", "red"),
      values = scales::rescale(c(-10, -5, 0, 0, 1))) + 
  geom_hline(yintercept=inc,size=2)


## combined anchor1 and anchor2 differentially expressed genes. 
anchors.df = rbind(anchors1.rpkm[which(anchors1.rpkm$df==TRUE),-2],
  anchors2.rpkm[which(anchors2.rpkm$df==TRUE),-2])
anchors.df = anchors.df[order(-anchors.df$cluster),]
num = rev(table(anchors.df$cluster))
inc = 0
for(i in 1:length(num)) inc[i+1] = inc[i] + num[i]

mat = as.matrix(anchors.df[,6:17])
mat = mat[,c(1,7,2,8,3,9,4,10,5,11,6,12)]
mat = log2(sweep(mat+1e-6, 1, apply(mat,1, mean), "/"))
#hc.od = NULL
for (i in 1:6) {
hc = hclust(as.dist( 1- cor(t(mat[which(anchors.df$cluster==i),]))))
mat[which(anchors.df$cluster==i),] = mat[which(anchors.df$cluster==i),][hc$order,]
#hc.od  = c(hc.od, hc$order) 
}

#mat = mat[order(-anchors.df$cluster,hc.od),]
rownames(mat) = 1:nrow(mat)
mat.melt = melt(mat)

pdf("figures/loop_cluster_anchor_gene_diff.pdf")
ggplot(mat.melt,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
#  scale_fill_gradient2(high="red",mid="white",low="white") +
  scale_fill_gradientn(colours = c("darkblue", "white", "red"),
      values = scales::rescale(c(-10, -5, 0, 1, 1))) +
  geom_hline(yintercept=inc,size=1)

for( i in 1:6){
  tmp = mat[which(anchors.df$cluster==i),]
  rownames(tmp) = 1:nrow(tmp)
  tmp.melt = melt(tmp)
  print(ggplot(tmp.melt,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
#  scale_fill_gradient2(high="red",mid="white",low="white") +
  scale_fill_gradientn(colours = c("darkblue", "white", "red"),
      values = scales::rescale(c(-10, -5, 0, 1, 1))) + 
  ggtitle(paste0("cluster-",i))
  )
}
dev.off()



setwd("../../analysis/hiccup_loops/")
options(scipen=99)
##table 1: anchors.  
anchors = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
## table 2: anchors2tss
a2tss = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)
a2tss$name = paste(a2tss$V1, a2tss$V2+10000)
## table 3: gene rpkm 
feature = read.delim("../../data/rnaseq/gene.rpkm.edger.txt")
feature$fdr = p.adjust(feature$PValue)

keep = names(table(anchors$cluster_dense))[which(table(anchors$cluster_dense)>50)]
anchors.keep = anchors[which(anchors$cluster_dense %in% keep),]
# merge loops with genes
m1 = merge(anchors.keep, a2tss, by="name")
# write the genes for each cluster for Pathway analysis. 
for (name in c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")){
  tmp = unique(m1[which(m1$cluster_dense==name),"V7"])
  write.table(tmp,paste0("clusters/genes/",name,".txt"),row.names=F,quote=F,col.names=F)
  }


m2 = merge(m1, feature, by.x="V7",by.y="Geneid",all.x=T)


m2$df = m2$fdr < 0.05

anchor.df = m2[which(m2$df==TRUE),]
anchor.df = anchor.df[order(anchor.df$cluster_dense),]
num = table(factor(anchor.df$cluster_dense))
inc = 0
for(i in 1:length(num)) inc[i+1] = inc[i] + num[i]

mat = as.matrix(anchor.df[,20:31])
mat = mat[,c(1,7,2,8,3,9,4,10,5,11,6,12)]

for (i in 1:length(num)) {
hc = hclust(as.dist( 1- cor(t(mat[which(anchor.df$cluster_dense==names(num)[i]),]))))
mat[which(anchor.df$cluster_dense==names(num)[i]),] = mat[which(anchor.df$cluster_dense==names(num)[i]),][hc$order,]
}
# log transformation 
mat = log2(sweep(mat+1e-6, 1, apply(mat,1, mean), "/"))

rownames(mat) = 1:nrow(mat)
mat.melt = melt(mat)

pdf("figures/replicated.anchors.cluster.gene.expression.pdf",height=20,width=6) 
ggplot(mat.melt,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_y_continuous(breaks=inc[-1],labels = names(num))+ 
  scale_fill_gradientn(colours = c("darkblue", "white", "red"),
      values = scales::rescale(c(-10, -5, 0, 1, 1))) +
  geom_hline(yintercept=inc,size=1) 
dev.off()



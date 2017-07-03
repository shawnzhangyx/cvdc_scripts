setwd("../../analysis/hiccup_loops/")
options(scipen=99)
pdf("figures/replicated.anchors.cluster.histone.pdf",height=20,width=6) 
##table 1: anchors.  

for (mark in c("H3K27ac","H3K27me3","H3K4me1","H3K4me3")){
print(mark)
anchors = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
## table 2: anchors2peak
a2peak = data.frame(fread(paste0("overlap_anchors_to_features/anchor.",mark,"_merged_peaks.txt"),header=F))
a2peak$name = paste(a2peak$V1, a2peak$V2+10000)
## table 3: gene rpkm 
feature = data.frame(fread(paste0("../../data/chipseq/edger/",mark,".rpkm.fc.edger.txt")))
feature$fdr = p.adjust(feature$PValue)

keep = names(table(anchors$cluster_dense))[which(table(anchors$cluster_dense)>50)]
anchors.keep = anchors[which(anchors$cluster_dense %in% keep),]
# merge loops with genes
m1 = merge(anchors.keep, a2peak, by="name")
m2 = merge(m1, feature, by.x="V7",by.y="Geneid",all.x=T)

m2$df = m2$fdr < 0.05

anchor.df = m2[which(m2$df==TRUE),]
anchor.df = anchor.df[order(anchor.df$cluster_dense),]
num = table(factor(anchor.df$cluster_dense))
inc = 0
for(i in 1:length(num)) inc[i+1] = inc[i] + num[i]

mat = as.matrix(anchor.df[,21:32])

for (i in 1:length(num)) {
hc = hclust(as.dist( 1- cor(t(mat[which(anchor.df$cluster_dense==names(num)[i]),]))))
mat[which(anchor.df$cluster_dense==names(num)[i]),] = mat[which(anchor.df$cluster_dense==names(num)[i]),][hc$order,]
}
# log transformation 
mat = log2(sweep(mat+1e-6, 1, apply(mat,1, mean), "/"))

rownames(mat) = 1:nrow(mat)
mat.melt = melt(mat)

print(ggplot(mat.melt,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_y_continuous(breaks=inc[-1],labels = names(num))+ 
  scale_fill_gradientn(colours = c("darkblue", "white", "red"),
      values = scales::rescale(c(-10, -5, 0, 1, 1))) +
  geom_hline(yintercept=inc,size=1) + ggtitle(mark))
}

dev.off()



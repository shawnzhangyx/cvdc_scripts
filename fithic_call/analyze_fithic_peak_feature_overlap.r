setwd("../../analysis/fithic/merged_peaks_overlap_features")

a1 = data.frame(fread("fithic.anchor1.features.txt"))
a2 = data.frame(fread("fithic.anchor2.features.txt"))
bg = data.frame(fread("all_genomic_bins.features.txt"))

colSums(a1[,7:12]>0)/nrow(a1)
colSums(a2[,7:12]>0)/nrow(a2)
colSums(bg[,4:9]>0)/nrow(bg)

b1 = a1[,7:12]>0
b2 = a2[,7:12]>0
colnames(b1) = colnames(b2) = c("CTCF","ATAC","H3K4me1","H3K4me3","H3K27me3","H3K27ac")

o1 = order(b1[,1],b1[,2],b1[,3],b1[,4],b1[,5],b1[,6])

c1 = b1[o1,]
c2 = b2[o1,]

melt1 = melt(c1,id.var=rownames(c1))
melt2 = melt(c2,id.var=rownames(c2))

pdf("peak_sorted_by_feature_overlap.pdf")
ggplot(melt1,aes(x=Var2,y=Var1,fill=value)) + geom_tile()
ggplot(melt2,aes(x=Var2,y=Var1,fill=value)) + geom_tile()

dev.off()


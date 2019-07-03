setwd("../../analysis/hiccup_loops/")
a=read.delim("overlap_anchors_to_features/anchor.all_features.txt")
b=data.frame(fread("overlap_anchors_to_features/all_genomic_bins.features.txt"))

a1 = a[,-c(1,2,3)]
a1 = a1>0

melted = melt(a1)
b1 = b[,-c(1,2,3)]
b1 = b1>0
melted2 = melt(b1)

pdf("figures/anchor.features.pdf",height=6,width=6)
ggplot(melted, aes(x=Var2,fill=value)) +
    geom_bar(position="fill",stat="count")+
    theme( 
    axis.text.x = element_text(size=10,angle = 90, hjust = 1))


ggplot(melted2, aes(x=Var2,fill=value)) +
    geom_bar(position="fill",stat="count")
dev.off()


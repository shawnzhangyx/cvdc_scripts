setwd("../../analysis/customLoops")
loops=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loops$a1 = sub("(.*) (.*) (.*)","\\2",loops$name)
loops$a2 = sub("(.*) (.*) (.*)","\\3",loops$name)
loops$distance = as.numeric(loops$a2)-as.numeric(loops$a1)

pdf("figures/loop_cluster_distance.pdf",width=5,height=5)
ggplot(loops, aes(x=factor(cluster), y=distance)) + 
  geom_violin(width=0.5) + scale_y_log10(0,1e7) +
  theme_bw()
dev.off()

#ggplot(loops, aes(x=distance,fill=factor(cluster))) +
#  geom_histogram(aes(y=..density..),bins=60,position="identity") +
#  scale_x_log10(breaks=c(1e3,1e4,1e5,5e5,1e6,1e7)) + 
#  facet_wrap(~cluster,ncol=6) + coord_flip() + 
#  theme_bw()



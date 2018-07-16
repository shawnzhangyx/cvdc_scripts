setwd("../../analysis/hervh")
a=read.delim("multi_seq_aln/LTR_Kdist.txt",header=F)
a$rank = as.numeric( sub("multi_seq_aln\\/pairs\\/HERVH(.*).5P.bed.afa","\\1",a$V1))
a$tier = ceiling(a$rank/50)

#plot(a$rank,a$V2)

library(gridExtra) 

pdf("figures/LTR_divergence.pdf")
g1 = ggplot(a) + geom_point(aes(x=rank,y=V2)) +
  geom_smooth(aes(x=rank,y=V2)) + 
  ylab("Divergence") + ylim(0,0.3) +
  theme_bw()

g2 = ggplot(a) + geom_boxplot(aes(factor(tier),V2)) +
  ylab("Divergence") + ylim(0,0.3) +
  theme_bw()

grid.arrange(g1,g2)
dev.off()



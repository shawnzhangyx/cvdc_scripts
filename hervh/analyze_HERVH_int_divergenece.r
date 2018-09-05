setwd("../../analysis/hervh")
a=read.delim("multi_seq_aln/HERVH_int_Kdist.txt",header=F)
a$rank = as.numeric( sub("multi_seq_aln\\/HERVH_int_human_chimp\\/HERVH(.*)..fa.afa","\\1",a$V1))
a$tier = ceiling(a$rank/50)

b=read.delim("multi_seq_aln/5p_LTRs.txt",header=F)
d = read.delim("hervh.sorted_rnaseq.strand.bed",header=F)
d$rank = 1:nrow(d)
d$name = paste0("HERVH",1:nrow(d))
b$rank = d$rank[match(b$V4,d$V4)]

a$type = b$V10[match(a$rank,b$rank)]

#plot(a$rank,a$V2)

library(gridExtra) 

pdf("figures/Human_Chimp_divergence.pdf",width=4,height=3)
g1 = ggplot(a) + geom_point(aes(x=rank,y=V2)) +
  geom_smooth(aes(x=rank,y=V2)) + 
  ylab("Divergence") + ylim(0,0.3) +
  theme_bw()

g2 = ggplot(a) + geom_boxplot(aes(factor(tier),V2)) +
  ylab("Divergence") + ylim(0,0.3) +
#  theme_bw()
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1),
    panel.background = element_rect(fill = NA, colour = "black"),
    panel.grid = element_blank()
    )


g1
g2
dev.off()



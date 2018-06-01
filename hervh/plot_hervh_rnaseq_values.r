setwd("../../analysis/hervh/")

a=read.delim("herv.rnaseq.sorted.txt",header=F)

a$rank = 1:nrow(a)

pdf("figures/rnaseq.sorted_by_rpkm.D00.pdf",height=3,width=4)

ggplot(subset(a,rank<200)) + 
  #geom_bar(aes(x=rank,y=V2),stat="identity") + 
  geom_point(aes(x=rank,y=V4),color='#D1E5EF') +
  geom_point(aes(x=rank,y=V3),color='#68A9CF') +
  geom_point(aes(x=rank,y=V2),color='#2267AD') +  
  xlab("Rank") + ylab("RPKM") + xlim(200,0)+
  scale_y_sqrt(breaks=c(0,10,100,500,1000,2000)) + 
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )
  dev.off()

#  theme_bw() 

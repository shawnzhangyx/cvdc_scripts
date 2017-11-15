setwd("../../analysis/ab_compartments/")
a=read.delim("pc1_data/combined.matrix",header=F)


cor = cor((a[,-c(1:3)]))

dist = as.dist(1-cor)

hc = hclust(dist,method="average")
hc$labels=paste(rep(c("D00","D02","D05","D07","D15","D80"),each=2),rep(c("Rep1","Rep2"),6),sep='_')
hc$order = 1:12
pdf("compartmentAB_hclust.pdf",height=5,width=5)
plot(hc)
dev.off()



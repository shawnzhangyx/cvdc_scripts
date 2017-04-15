setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/ab_compartments/clusters")
inc = read.delim("gene_increase_rpkm.txt",header=F)
colnames(inc)[-1] = paste0("D",rep(c(0,2,5,7,15,80),each=2),rep(c(".1",".2"),6))
mmax = apply(inc[,-1],1,max)
inc.f = inc[which(mmax>1),]
melted = melt(inc.f)
g.inc = ggplot(melted,aes(x=variable,y=V1,fill=sqrt(value)))+geom_tile() + 
  scale_fill_gradient2(low='blue',mid="white",high='red') + 
  ggtitle("Gene w/ Compartment Increase")

dec = read.delim("gene_decrease_rpkm.txt",header=F)
colnames(dec)[-1] = paste0("D",rep(c(0,2,5,7,15,80),each=2),rep(c(".1",".2"),6))
mmax = apply(dec[,-1],1,max)
dec.f = dec[which(mmax>1),]
melted = melt(dec.f)
g.dec = ggplot(melted,aes(x=variable,y=V1,fill=sqrt(value)))+geom_tile() +
  scale_fill_gradient2(low='blue',mid="white",high='red') + 
  ggtitle("Gene w/ Compartment Decrease")



pdf("gene_rpkm_overlapWithTopCompartmentChanges.pdf")
g.inc
g.dec
dev.off()


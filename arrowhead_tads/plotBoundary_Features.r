
setwd("../../analysis/tads")
for ( name in c("D00","D80","gain")) {

stage = read.table(paste0("stage_specific_tads/",name,".within.tads"))

stage$a1 = paste(stage$V1,stage$V2)
stage$a2 = paste(stage$V1,stage$V3)

ctcf = read.delim("overlap_anchors_to_features/anchor.CTCF.norm_counts.txt")
ctcf.f = read.delim("overlap_anchors_to_features/anchor.CTCF.f.norm_counts.txt")
ctcf.r = read.delim("overlap_anchors_to_features/anchor.CTCF.r.norm_counts.txt")


ctcf$name = paste(ctcf$chr,ctcf$start+20000)
ctcf.f$name = paste(ctcf.f$chr,ctcf.f$start+20000)
ctcf.r$name = paste(ctcf.r$chr,ctcf.r$start+20000)


a1.all = ctcf[match(stage$a1,ctcf$name),4:7]
a2.all = ctcf[match(stage$a2,ctcf$name),4:7]

a1.f = ctcf.f[match(stage$a1,ctcf.f$name),4:7]
a2.f = ctcf.f[match(stage$a2,ctcf.f$name),4:7]

a1.r = ctcf.r[match(stage$a1,ctcf.r$name),4:7]
a2.r = ctcf.r[match(stage$a2,ctcf.r$name),4:7]

a1.all.norm = sweep(a1.all,1,apply(a1.all,1,max),'/')
m1 = melt(as.matrix(a1.all.norm))
a2.all.norm = sweep(a2.all,1,apply(a2.all,1,max),'/')
m2 = melt(as.matrix(a2.all.norm))
library(gridExtra)
pdf(paste0("figures/",name,".boundary.CTCF.pdf"))
g1 = ggplot(m1, aes(x=Var2,y=factor(Var1),fill=value))+ geom_tile() + 
  scale_fill_gradient2(mid="white",high="red")
g2 = ggplot(m2, aes(x=Var2,y=factor(Var1),fill=value))+ geom_tile() +
  scale_fill_gradient2(mid="white",high="red")
grid.arrange(g1,g2,ncol=2)

g1 =  ggplot(m1,aes(x=Var2,y=value)) + geom_boxplot()+ geom_jitter(width=0.1) 
g2 =  ggplot(m2,aes(x=Var2,y=value)) + geom_boxplot()+ geom_jitter(width=0.1)
grid.arrange(g1,g2,ncol=2)

dev.off()

a1.f.norm = sweep(a1.f,1,apply(a1.f,1,max),'/')
m1 = melt(as.matrix(a1.f.norm))
a2.f.norm = sweep(a2.f,1,apply(a2.f,1,max),'/')
m2 = melt(as.matrix(a2.f.norm))

a1.r.norm = sweep(a1.r,1,apply(a1.r,1,max),'/')
m3 = melt(as.matrix(a1.r.norm))
a2.r.norm = sweep(a2.r,1,apply(a2.r,1,max),'/')
m4 = melt(as.matrix(a2.r.norm))

library(gridExtra)
pdf(paste0("figures/",name,".boundary.CTCF.orientation.pdf"))
g1 = ggplot(m1, aes(x=Var2,y=factor(Var1),fill=value))+ geom_tile() +
  scale_fill_gradient2(mid="white",high="red")
g2 = ggplot(m2, aes(x=Var2,y=factor(Var1),fill=value))+ geom_tile() +
  scale_fill_gradient2(mid="white",high="red")
g3 = ggplot(m3, aes(x=Var2,y=factor(Var1),fill=value))+ geom_tile() +
  scale_fill_gradient2(mid="white",high="red")
g4 = ggplot(m4, aes(x=Var2,y=factor(Var1),fill=value))+ geom_tile() +
  scale_fill_gradient2(mid="white",high="red")
grid.arrange(g1,g2,g3,g4,ncol=2)
g1 =  ggplot(m1,aes(x=Var2,y=value)) + geom_boxplot()+ geom_jitter(width=0.1)
g2 =  ggplot(m2,aes(x=Var2,y=value)) + geom_boxplot()+ geom_jitter(width=0.1)
g3 =  ggplot(m3,aes(x=Var2,y=value)) + geom_boxplot()+ geom_jitter(width=0.1)
g4 =  ggplot(m4,aes(x=Var2,y=value)) + geom_boxplot()+ geom_jitter(width=0.1)
grid.arrange(g1,g2,g3,g4,ncol=2)

dev.off()

}

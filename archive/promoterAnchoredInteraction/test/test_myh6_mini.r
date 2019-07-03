setwd("../../analysis/promoterAnchoredInteractions")
meta = readLines("../../data/hic/meta/names.txt")
glist=list()
a = read.table("MYH6.contacts.txt")

blist = list()
for (name in meta){
print(name)
b = read.table(paste0(name,"/all.dist.total"))
b$mean = b$V2/b$V3/2
b$name = name
blist[[name]] = b
}
b = do.call(rbind,blist)


#out = a[which(a$V1 == 23870000 | a$V2 == 23870000),]
#sorted = out[order(-out$V3),]
sorted = a
sorted$dist = abs(sorted$V2-sorted$V3)
sorted$pos = ifelse(sorted$V2==23870000,sorted$V3,sorted$V2)
sorted$expected = b$mean[match(paste(sorted$V1,sorted$dist),paste(b$name,b$V1))]
sorted$logP = -log10(ppois(sorted$V4,sorted$expected,lower.tail=F))
sorted = sorted[order(-sorted$logP),]
sorted$day = substr(sorted$V1,1,3)

ctcf = data.frame(fread("../../data/tfChIPseq/10k_bins/CTCF.10kb.rpm.txt"))
ctcf = ctcf[which(ctcf$V1=="chr14" & ctcf$V2>23870000-1e6 & ctcf$V3<23870000+1e6),]
ctcf.m = melt(ctcf,id.vars=c("V1","V2","V3"))

h3k27ac = data.frame(fread("../../data/chipseq/10k_bins/H3K27ac.10kb.rpm.txt"))
h3k27ac = h3k27ac[which(h3k27ac$V1=="chr14" & h3k27ac$V2>23870000-1e6 & h3k27ac$V3<23870000+1e6),]
h3k27ac.m = melt(h3k27ac,id.vars=c("V1","V2","V3"))


#data_list[[name]] = sorted
#  g1=ggplot(subset(sorted,dist<1e6),aes(x=pos)) + 
#  geom_point(aes(y=logP,color=day))  
  g0 = ggplot(subset(sorted,dist<1e6), aes(x=pos,color=day,y=V4)) + geom_point()

  g1=ggplot(subset(sorted,dist<1e6),aes(x=pos,y=day,fill=logP)) +
  geom_tile() + scale_fill_gradient2(high="red",mid="white")

  g2=ggplot(ctcf.m,aes(x=V2,y=variable,fill=value)) +
    geom_tile() + scale_fill_gradient2(high="red",mid="white")
  g3=ggplot(h3k27ac.m,aes(x=V2,y=variable,fill=value)) +
      geom_tile() + scale_fill_gradient2(high="red",mid="white")



require(gridExtra)
grid.arrange(g0,g1,g2,g3,ncol=1)
#dev.off()



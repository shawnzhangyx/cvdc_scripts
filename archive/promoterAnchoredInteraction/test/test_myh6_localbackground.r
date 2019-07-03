setwd("../../analysis/promoterAnchoredInteractions")
meta = readLines("../../data/hic/meta/names.txt")
glist=list()
a = read.table("MYH6.contacts.txt")

blist = list()
for (name in meta){
print(name)
b = read.table(paste0(name,"/all.dist.total"))
b$mean = b$V2/b$V3/2
b$ratio = b$V2/max(b$V2)
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

b.d00 = b[which(b$name=="D15_HiC_Rep1"),]
d00 = sorted[which(sorted$V1=="D15_HiC_Rep1" & sorted$dist<1e6),]

for(i in 1:nrow(d00)){
  print(i)
  tmp = d00[which( abs(d00$pos-d00$pos[i]) <=1e5),]
  tmp$dist = abs(tmp$pos-d00$pos[i])
  tmp$exp.corrected = tmp$V4*b.d00$ratio[match(tmp$dist,b.d00$V1)]
  tmp$exp.corrected[tmp$dist==0]=d00$expected[i]
  d00$exp.corrected[i] = max(tmp$exp.corrected,na.rm=T)
  }

d00$logP.adj = -log10(ppois(d00$V4,d00$exp.corrected,lower.tail=F))


ggplot(d00,aes(x=pos)) +
  geom_col(aes(y=V4,color="ob")) +
  geom_line(aes(y=expected,color="exp")) +
  geom_line(aes(y=exp.corrected,color="corrected")) +
  geom_point(aes(y=logP,color=c("logP.sig","logP.insig")[(logP<2) +1 ]))+
  geom_point(aes(y=logP.adj,color=c("logP.adj.sig","logP.adj.insig")[(logP.adj<2) +1 ]))


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



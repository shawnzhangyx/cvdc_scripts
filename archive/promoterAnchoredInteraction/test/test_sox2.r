setwd("../../analysis/promoterAnchoredInteractions")
meta = readLines("../../data/hic/meta/names.txt")
glist=list()
for (name in meta){
print(name)
a = data.frame(fread(paste0("../../data/hic/matrix/",name,"/3_10000.txt")))
b = read.table(paste0(name,"/all.dist.total"))
b$mean = b$V2/b$V3/2
#b$mean[1] = b$mean/2

out = a[which(a$V1 == 181420000 | a$V2 == 181420000),]
sorted = out[order(-out$V3),]
sorted$dist = abs(sorted$V1-sorted$V2)
sorted$pos = ifelse(sorted$V1==181420000,sorted$V2,sorted$V1)
sorted$expected = b$mean[match(sorted$dist,b$V1)]
sorted$logP = -log10(ppois(sorted$V3,sorted$expected,lower.tail=F))
sorted = sorted[order(-sorted$logP),]
#data_list[[name]] = sorted
  glist[[name]] = ggplot(subset(sorted,dist<2e6),aes(x=pos)) + 
  geom_col(aes(y=V3,color="ob")) +
  geom_line(aes(y=expected,color="exp")) + 
  geom_point(aes(y=logP,color=c("logP.sig","logP.insig")[(logP>2) +1 ])) + 
  ylim(0,50) + ggtitle(name)
#  glist[[length(glist)+1]]= g
}

require(gridExtra)
pdf("sox2.pdf",height=30,width=30)
grid.arrange(grobs=glist,ncol=2)
dev.off()



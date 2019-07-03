setwd("../../analysis/hiccup_loops")
a=read.delim("replicated_loops/loops.cpb.logFC.edger.dynamic.cluster.txt")

tab = a[,c("chr","x1","y1","cluster")]
tab$x1 = floor(tab$x1/10000)
tab$y1 = floor(tab$y1/10000)

tab2 = tab[which(tab$chr=="chr1"),]

cov = matrix(0,nrow=6,ncol = max(tab2$y1))

for (i in 1:nrow(tab2)){
  print(i)
  cov[tab2$cluster[i],tab2$x1[i]:tab2$y1[i]] = 
    cov[tab2$cluster[i],tab2$x1[i]:tab2$y1[i]] + 1
  }

melted = melt(cov)

ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white")

#  facet_wrap(~factor(Var1))
#  scale_fill_gradientn(colors="

b =read.delim("../../data/rnaseq/gene.rpkm.cluster.txt")
loc = data.frame(fread("../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed"))
loc$cluster = b$cluster[match(loc$V4,b$Geneid)]
loc = loc[!is.na(loc$cluster),]

loc2 = loc[which(loc$V1=="chr1"),]
loc2$pos = floor(loc2$V2/10000)
loc3 = loc2[!duplicated(loc2$V4,loc2$pos),]

cov2 = matrix(0,nrow=6,ncol = max(tab2$y1))

for (i in 1:nrow(loc3)){
  if (loc3$pos[i] < max(tab2$y1) ) {
  cov2[loc3$cluster[i],loc3$pos[i]] = cov2[loc3$cluster[i],loc3$pos[i]] + 1
#  cov2[loc3$cluster[i],(loc3$pos[i]-10):(loc3$pos[i]+10)] = cov2[loc3$cluster[i],(loc3$pos[i]-10):(loc3$pos[i]+10)] + 1
  }
  }

melted2 = melt(cov2)

ggplot(melted2, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white")

which(cov2[5,]>0)


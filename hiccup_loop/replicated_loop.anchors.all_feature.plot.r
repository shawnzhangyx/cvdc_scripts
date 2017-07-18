setwd("../../analysis/hiccup_loops")

all = read.delim("overlap_anchors_to_features/anchor.all_features.txt")
rep = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")

m = merge(rep,all, by.x=c("V1","V2","V3"),by.y=c("chr","start","end"))
m[,c(9:15)] = m[,9:15]>0

#tab = m[order(m$CTCF,m$ATAC,m$H3K4me1,m$H3K27ac,m$H3K27me3,m$H3K4me3,m$TSS),-c(1:8)]
tab = m[order(m$H3K4me3,m$H3K27ac,m$H3K27me3),-c(1:10)]
rownames(tab) = 1:nrow(tab)
melted = melt(as.matrix(tab))

ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile()

##
head(m[which(m$H3K27me3==TRUE & m$H3K27ac==TRUE & m$H3K4me3==FALSE),])


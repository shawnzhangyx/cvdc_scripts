require(gridExtra)

setwd("../../analysis/hiccup_loops/clusters/")
km = read.delim("cpb.dynamic.clusters.txt")
K = max(km$cluster)
num = table(km$cluster)
num.inc = sapply(1:length(num), function(i){ sum(num[1:i])})

a1 = data.frame(fread("dynamic.loop.anchor1.bed"))
a2 = data.frame(fread("dynamic.loop.anchor2.bed"))
a1$V5 = 1:nrow(a1)
a2$V5 = 1:nrow(a2)

f = read.delim("../overlap_features/anchor.all_features.txt")
a1.out = merge(a1,f,by.x=c("V1","V2","V3"),by.y = c("chr","start","end"),all.x=TRUE)
a1.out = a1.out[order(a1.out$V5),]
mat1 = as.matrix(a1.out[,-c(1:5)]>0)
rownames(mat1) = 1:nrow(mat1)
melted1 = melt(mat1)
g1 = ggplot(melted1,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  geom_abline(intercept=num.inc) +
  annotate("text",x=rep(6.5,K),y=num.inc-100,label=1:K) +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )
a2.out = merge(a2,f,by.x=c("V1","V2","V3"),by.y = c("chr","start","end"),all.x=TRUE)
a2.out = a2.out[order(a2.out$V5),]
mat2 = as.matrix(a2.out[,-c(1:5)]>0)
rownames(mat2) = 1:nrow(mat2)
melted2 = melt(mat2)
g2 = ggplot(melted2,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  geom_abline(intercept=num.inc) +
  annotate("text",x=rep(6.5,K),y=num.inc-100,label=1:K) +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )
pdf("dynamic.anchors.all_feature.pdf")
grid.arrange(g1,g2,ncol=2)
dev.off()

mark="H3K27ac"
for (mark in c("H3K27ac","H3K27me3","H3K4me1","H3K4me3")){#,"atac")){
f = read.delim(paste0("../overlap_features/anchor.",mark,".peaks.txt"))
a1.out = merge(a1,f,by.x=c("V1","V2","V3"),by.y = c("chr","start","end"),all.x=TRUE)
a1.out = a1.out[order(a1.out$V5),]
mat1 = as.matrix(a1.out[,-c(1:5)]>0)
rownames(mat1) = 1:nrow(mat1)
melted1 = melt(mat1)
g1 = ggplot(melted1,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  geom_abline(intercept=num.inc) +
  annotate("text",x=rep(6.5,K),y=num.inc-100,label=1:K) +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )
a2.out = merge(a2,f,by.x=c("V1","V2","V3"),by.y = c("chr","start","end"),all.x=TRUE)
a2.out = a2.out[order(a2.out$V5),]
mat2 = as.matrix(a2.out[,-c(1:5)]>0)
rownames(mat2) = 1:nrow(mat2)
melted2 = melt(mat2)
g2 = ggplot(melted2,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  geom_abline(intercept=num.inc) +
  annotate("text",x=rep(6.5,K),y=num.inc-100,label=1:K) +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )
pdf(paste0("dynamic.anchors.",mark,".peaks.pdf"))
grid.arrange(g1,g2,ncol=2)
dev.off()
}

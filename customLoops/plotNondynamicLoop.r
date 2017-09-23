setwd("../../analysis/customLoops")
loop = read.delim("loops/loops.cpb.logFC.edger.nondynamic.txt",stringsAsFactors=F)
a1 = read.delim("loops/loops.nondynamic.cluster.anchor1.txt",stringsAsFactors=F)
a2 = read.delim("loops/loops.nondynamic.cluster.anchor2.txt",stringsAsFactors=F)
## leave cluster D02
clu=0
#loopm = loop[which(loop$cluster==clu),]
#a1 = a1p[which(loop$cluster==clu),]
#a2 = a2p[which(loop$cluster==clu),]

## move promoter to a1. 
a2pi = which(a2$H3K4me3>0 & a1$H3K4me3==0)
tmp = a2[a2pi,]
a2[a2pi,] = a1[a2pi,]
a1[a2pi,] = tmp

cor.h3k27me3 = sapply(1:nrow(a1),function(x){ cor(as.numeric(a1[x,10:15]),1:6)})
cor.h3k27ac  = sapply(1:nrow(a1),function(x){ cor(as.numeric(a1[x,16:21]),1:6)})
### calculate 
### sort by an defined order. 
od = order(a1$H3K4me3<1, a2$H3K4me3<1,cor.h3k27ac,cor.h3k27me3)
a1 = a1[od,]
a2 = a2[od,]

lp = loop[,seq(2,13,2)] + loop[,seq(3,13,2)]
lp = sweep(lp,1,apply(lp,1,max),'/')[od,]

mat1 = a1[,4:37]
for (i in seq(1,25,6)){
mat1[,i:(i+5)] = sweep(mat1[,i:(i+5)],1,apply(mat1[,i:(i+5)],1,max),'/')
}
mat1[,31:34] = sweep(mat1[,31:34],1,apply(mat1[,31:34],1,max),'/')
mat1[is.na(mat1)] = 0
mat2 = a2[,4:37]
for (i in seq(1,25,6)){
mat2[,i:(i+5)] = sweep(mat2[,i:(i+5)],1,apply(mat2[,i:(i+5)],1,max),'/')
}
mat2[,31:34] = sweep(mat2[,31:34],1,apply(mat2[,31:34],1,max),'/')
mat2[is.na(mat2)] = 0

colnames(lp) = sub("(D..)_.","HiC_\\1",colnames(lp))
colnames(mat1) = paste0("A1.",colnames(mat1))
colnames(mat2) = paste0("A2.",colnames(mat2))
comb = cbind(lp,mat1,mat2)
rownames(comb) = 1:nrow(comb)

melted = melt(as.matrix(comb))

pdf(paste0("figures/cluster",clu, ".heatmap.pdf"),height=5,width=12)
ggplot(melted,aes(x=Var2,y=Var1,fill=value))+ geom_tile() + 
  scale_fill_gradient2(high="red",mid="lightyellow") +
  geom_vline(xintercept=c(seq(6,36,6),40,seq(46,70,6))+0.5)+
  annotate("text",x=c(seq(0,36,6),40,seq(46,70,6))+0.6,y=nrow(comb)*1.02,
    label=c("HiC",rep(c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","RNAseq","CTCF"),2)),
    hjust = 0)+
  xlab("Marks") + ylab("Loops")+
  theme( 
  axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()

rownames(comb) = loop$name[loop$cluster==clu][od]
melted = melt(as.matrix(comb))
pdf(paste0("figures/cluster_with_names/cluster",clu, ".heatmap.pdf"),height=nrow(comb)/8,width=12)
ggplot(melted,aes(x=Var2,y=Var1,fill=value))+ geom_tile() +
  scale_fill_gradient2(high="red",mid="lightyellow") +
  geom_vline(xintercept=c(seq(6,36,6),40,seq(46,70,6))+0.5)+
  annotate("text",x=c(seq(0,36,6),40,seq(46,70,6))+0.6,y=nrow(comb)*1.02,
    label=c("HiC",rep(c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","RNAseq","CTCF"),2)),
    hjust = 0)+
  xlab("Marks") + ylab("Loops")+
  theme(
  axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()

#name = loop$name[loop$cluster==clu][od]
#out = cbind(name,name,comb)
#write.table(out,paste0("clusters/",clu,".mat.cdt"),row.names=F,sep='\t',quote=F)


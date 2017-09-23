setwd("../../analysis/customLoops/")

dyn = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
a2peak = read.delim("overlap_anchors_to_features/anchor.atac_merged_peaks.txt",header=F,stringsAsFactors=F)
peak = read.delim("../../data/atac/counts/atac.fpkm",stringsAsFactors=F)
rpkm = cbind(peak[,1],(peak[,seq(7,18,2)]+peak[,seq(8,18,2)])/2)
colnames(rpkm) = c("Annotation.Divergence","D00","D02","D05","D07","D15","D80")
#rpkm.cluster = read.delim("../../data/rpkmseq/gene.rpkm.cluster.txt",stringsAsFactors=F)
dyn$chr = sub("(.*) (.*) (.*)","\\1",dyn$name)
dyn$start = sub("(.*) (.*) (.*)","\\2",dyn$name)
dyn$end = sub("(.*) (.*) (.*)","\\3",dyn$name)
dyn$a1 = paste(dyn$chr,dyn$start)
dyn$a2 = paste(dyn$chr,dyn$end)

a2peak$anchor = paste(a2peak$V1,a2peak$V2+10000)

for (clu in 1:5){
print(clu)
#clu = 1
anchors = unique(c(dyn$a1[dyn$cluster==clu],dyn$a2[dyn$cluster==clu]))
tss = unique(a2peak$V7[which(a2peak$anchor %in% anchors)])
out = rpkm[which(rpkm$Annotation.Divergence %in% tss),]
out2 = cbind(peak[match(out$Annotation.Divergence,peak$Geneid),2:4],out[,-1])

cor = 1- cor(t(out[,2:7]))
cor[is.na(cor)] = 2
hc = hclust(as.dist(cor))

mat = out[hc$order,]
mat$Annotation.Divergence = factor(mat$Annotation.Divergence,levels=mat$Annotation.Divergence)
melted = melt(mat)
g1 = ggplot(melted,aes(x=variable,y=Annotation.Divergence,fill=log2(value))) + geom_tile() + 
  scale_fill_gradient2(high="red",mid="white",low="blue")
  
mat[,2:7] = sweep(mat[,2:7],1,apply(mat[,2:7],1,max),"/")
melted = melt(mat)
g2 = ggplot(melted,aes(x=variable,y=Annotation.Divergence,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white",low="blue")
require(gridExtra)
system("mkdir clusters/atac_peaks/")
pdf(paste0("clusters/atac_peaks/",clu,".atac_peaks.pdf"),width=10,height=nrow(mat)/10)
grid.arrange(grobs=list(g1,g2),nrow=1)
dev.off()
write.table(out2,paste0("clusters/atac_peaks/",clu,".atac_peaks.txt"),row.names=F,quote=F,sep='\t',col.names=F)
}



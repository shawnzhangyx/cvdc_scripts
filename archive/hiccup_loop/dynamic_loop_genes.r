setwd("../../analysis/hiccup_loops/")

dyn = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
a2tss = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F,stringsAsFactors=F)
rna = read.delim("../../data/rnaseq/gene.rpkm.txt",stringsAsFactors=F)
rna = cbind(rna[,1],(rna[,seq(2,13,2)]+rna[,seq(3,13,2)])/2)
colnames(rna) = c("Annotation.Divergence","D00","D02","D05","D07","D15","D80")
#rna.cluster = read.delim("../../data/rnaseq/gene.rpkm.cluster.txt",stringsAsFactors=F)
dyn$chr = sub("(.*) (.*) (.*)","\\1",dyn$name)
dyn$start = sub("(.*) (.*) (.*)","\\2",dyn$name)
dyn$end = sub("(.*) (.*) (.*)","\\3",dyn$name)
dyn$a1 = paste(dyn$chr,dyn$start)
dyn$a2 = paste(dyn$chr,dyn$end)

a2tss$anchor = paste(a2tss$V1,a2tss$V2+10000)

for (clu in 1:6){
print(clu)
#clu = 1
anchors = unique(c(dyn$a1[dyn$cluster==clu],dyn$a2[dyn$cluster==clu]))
tss = unique(a2tss$V7[which(a2tss$anchor %in% anchors)])
out = rna[which(rna$Annotation.Divergence %in% tss),]
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
pdf(paste0("clusters/",clu,".genes.pdf"),width=10,height=nrow(mat)/10)
grid.arrange(grobs=list(g1,g2),nrow=1)
dev.off()
write.table(out,paste0("clusters/",clu,".genes.txt"),row.names=F,quote=F,sep='\t')
}



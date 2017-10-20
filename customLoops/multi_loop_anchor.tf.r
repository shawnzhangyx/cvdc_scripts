setwd("../../analysis/customLoops")
require(ggrepel)

a = read.table("anchors/anchors.uniq.30k.num_loops.genes.txt")
tfs = read.delim("../../data/annotation/human_tfs/nrg2538-s3.txt",skip=11)
rpkm = read.delim("../../data/rnaseq/gene.rpkm.txt")

b = a[which(a$V8 %in% tfs$HGNC.symbol),c(8,4)]
rpkm$max = apply(rpkm[,2:13],1,max)
rpkm$max_stage = sapply(1:nrow(rpkm), function(i){ which.max(rpkm[i,2:13]) } )

b$rpkm = rpkm$max[match(b$V8,rpkm$Annotation.Divergence)]
b$max_stage = rep(c("D00","D02","D05","D07","D15","D80"),each=2)[rpkm$max_stage[match(b$V8,rpkm$Annotation.Divergence)]]


b$V4[b$V4>=5] = "5+"
b = b[order(b$V4,-b$rpkm),]

d = list()
for (i in unique(b$V4)){
  d[[i]] = b[which(b$V4==i),][1:10,]
  }
d = do.call(rbind,d)

pdf("figures/multiloop_anchor/anchor_TFs.pdf",height=5,width=10)
ggplot(b,aes(V4,rpkm)) +geom_point()  +scale_y_log10(limits=c(10,200)) +
  geom_label_repel(data=d,aes(V4,rpkm,label=V8,fill=max_stage),color="black") + 
#  scale_color_brewer(palette="Reds",direction=-1) +
  scale_fill_brewer(palette="RdBu") +
  xlab("Anchor Degree") + 
  theme_bw()
dev.off()


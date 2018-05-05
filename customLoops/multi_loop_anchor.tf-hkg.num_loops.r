setwd("../../analysis/customLoops")

anchors = read.table("anchors/anchors.uniq.30k.num_loops.genes.txt")
tss = read.table("overlap_anchors_to_features/anchor.gene_tss.unique.txt")


tfs = read.delim("../../data/annotation/human_tfs/nrg2538-s3.txt",skip=11)
tfs = tfs[which(tfs$Class %in% c("a","b")),]
#tfs = tss[which(tss$V7 %in% tfs$HGNC.symbol),]
b=read.table('../../data/annotation/GO_term/GO_heart_development.txt',header=T)

htfs = tfs[which(tfs$HGNC.symbol %in% toupper(x=b$Symbol)),]


hkgs = read.delim("../../data/annotation/human_hkg/hkg.txt",header=F)

exp = read.delim('../../data/rnaseq/gene.rpkm.expressed.type.txt')


tfs$num_loops = anchors$V4[match(tfs$HGNC.symbol,anchors$V8)]
hkgs$num_loops = anchors$V4[match(hkgs$V1,anchors$V8)]


tfs$num_loops[is.na(tfs$num_loops)] = 0
hkgs$num_loops[is.na(hkgs$num_loops)] = 0

ggplot() + geom_boxplot(data=tfs,aes(x=1,num_loops)) + 
  geom_boxplot(data=hkgs,aes(x=2,num_loops)) + 
  geom_boxplot(data=htfs,aes(x=3,num_loops))

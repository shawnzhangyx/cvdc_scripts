setwd("../../data/wgsData")

a = read.delim("wgs_denovo_case.overlap_atac_distal.txt",header=F)
b = read.delim("../../analysis/hiccup_loops/overlap_anchors_to_features/anchor.atac_merged_peaks.txt",header=F)
c = read.delim("../../analysis/hiccup_loops/replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
m1 = merge(a,b, by.x = "V4", by.y = "V7")
m1 = m1[,c(1,2,3,4,9,10,11)]
#colnames(m1) = c("peak","chr","start","end"
m2 = merge(m1,c, by.x=c("V1.y","V2.y","V3.y"),by.y = c("V1","V2","V3"))

loop = read.delim("../../analysis/hiccup_loops/replicated_loops/loops.DegreeOfAnchors.tab")
loop = loop[,1:6]
loop$a1= paste(loop$chr1, loop$x1)
loop$a2 = paste(loop$chr2, loop$y1)

g = read.delim("../../analysis/hiccup_loops/overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)
g$name = paste(g$V1,g$V2+10000)

a1 = merge(m2, loop, by.x="name",by.y="a1")
a1.g = merge(a1, g, by.x="a2",by.y= "name")

a2 = merge(m2, loop, by.x="name",by.y="a2")
a2.g = merge(a2, g, by.x="a1",by.y= "name")

unique(a1.g$V7); unique(a2.g$V7)

genes = unique( c(as.character(a1.g$V7), as.character(a2.g$V7)))

rna = read.delim("../rnaseq/gene.rpkm.edger.txt")

rna.out = rna[which(rna$Geneid %in% genes),]

write.table(rna.out$Geneid, "distal_genes.txt", quote=F,row.names=F,col.names=F)

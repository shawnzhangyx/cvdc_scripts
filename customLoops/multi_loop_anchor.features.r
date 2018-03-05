setwd("../../analysis/customLoops")

anchors = read.table("anchors/anchors.uniq.30k.num_loops.red.txt")
#merge anchor degreee greater than 5. 
anchors$V4[anchors$V4>5]=5
# number of genes. 
tss = read.table("overlap_anchors_to_features/anchor.gene_tss.unique.txt")
rpkm = read.delim("../../data/rnaseq/gene.rpkm.txt")
#rpkm$gt10 = apply(rpkm[,2:13],1,sum)> 100
rpkm$gt10 = apply(rpkm[,6:13],1,sum)> 100

tss = tss[which(tss$V7 %in% rpkm$Annotation.Divergence[which(rpkm$gt10==1)]),]

tss.agg = aggregate(V7~V1+V2+V3,tss, function(vec){length(which(vec!="."))})

a2tss = merge(anchors,tss.agg, by=c("V1","V2","V3"),all.x=T)
a2tss_sum = aggregate(V7~V4,a2tss, function(vec){ length(which(vec>0))/length(vec) })


# ggplot(a2tss,aes(factor(V4),V7>0)) +geom_bar()
pdf("figures/multiloop_anchor/anchor_loop_vs_TSS.pdf",height=4,width=4)
ggplot(a2tss,aes(x=V4,fill=V7>0)) +geom_bar(position="fill",stat="count")
dev.off()


## overlap with CTCF. 

ctcf = read.table("overlap_anchors_to_features/anchor.CTCF_merged_peaks.txt")
ctcf.agg = aggregate(V7~V1+V2+V3,ctcf, function(vec){length(which(vec!="."))})
a2ctcf = merge(anchors,ctcf.agg, by=c("V1","V2","V3"),all.x=T)
a2ctcf$V7[a2ctcf$V7>=4] = "4+"
#ggplot(a2ctcf,aes(factor(V4),V7)) + geom_violin()
pdf("figures/multiloop_anchor/anchor_loop_vs_CTCF.pdf",height=4,width=4)
ggplot(a2ctcf,aes(x=V4,fill=factor(V7))) + geom_bar(position="fill") +
  xlab("Anchor Degree") + ylab("Fraction") + 
  scale_fill_brewer(palette="Blues",name="#CTCF peaks") +
  theme_bw()
dev.off()


## overlap with Transcription factor. 
anchors = read.table("anchors/anchors.uniq.30k.num_loops.red.txt")
#merge anchor degreee greater than 5.
anchors$V4[anchors$V4>=5]="5+"
# number of genes.
tss = read.table("overlap_anchors_to_features/anchor.gene_tss.unique.txt")
tfs = read.delim("../../data/annotation/human_tfs/nrg2538-s3.txt",skip=11)
tfs = tfs[which(tfs$Class %in% c("a","b")),]
tfs = tss[which(tss$V7 %in% tfs$HGNC.symbol),]
tfs.agg = aggregate(V7~V1+V2+V3,tfs, function(vec){length(which(vec!="."))})
a2tfs = merge(anchors,tfs.agg, by=c("V1","V2","V3"),all.x=T)
a2tfs$V7[is.na(a2tfs$V7)]=0
a2tf_sum = aggregate(V7~V4,a2tfs, function(vec){ length(which(vec>0))/length(vec) })

pdf("figures/multiloop_anchor/anchor_loop_vs_TF.pdf",height=4,width=4)
ggplot(a2tf_sum, aes(V4,V7)) + geom_bar(stat="identity",fill=cbbPalette[6]) + 
    xlab("Anchor Degree") + ylab("Fraction of Anchor with TF") +
    theme_bw()
dev.off()

## overlap with housekeeping genes. 
anchors = read.table("anchors/anchors.uniq.30k.num_loops.red.txt")
#merge anchor degreee greater than 5.
anchors$V4[anchors$V4>=5]="5+"
# number of genes.
tss = read.table("overlap_anchors_to_features/anchor.gene_tss.unique.txt")
hkgs = read.delim("../../data/annotation/human_hkg/hkg.txt",header=F)
hkgs = tss[which(tss$V7 %in% hkgs$V1),]
hkgs.agg = aggregate(V7~V1+V2+V3,hkgs, function(vec){length(which(vec!="."))})
a2hkgs = merge(anchors,hkgs.agg, by=c("V1","V2","V3"),all.x=T)
a2hkgs$V7[is.na(a2hkgs$V7)]=0
a2hkg_sum = aggregate(V7~V4,a2hkgs, function(vec){ length(which(vec>0))/length(vec) })

pdf("figures/multiloop_anchor/anchor_loop_vs_HKG.pdf",height=4,width=4)
ggplot(a2hkg_sum, aes(V4,V7)) + geom_bar(stat="identity",fill=cbbPalette[6]) +
    xlab("Anchor Degree") + ylab("Fraction of Anchor with HKG") +
    theme_bw()
dev.off()



## overlap with histone mark 
anchors = read.table("anchors/anchors.uniq.30k.num_loops.red.txt")
#merge anchor degreee greater than 5.
anchors$V4[anchors$V4>=5]="5+"
histone = read.delim("overlap_anchors_to_features/anchor.H3K27ac.norm_counts.txt")
histone$max = apply(histone[,4:9],1,max) 
a2histone = merge(anchors,histone, by.x=c("V1","V2","V3"),
  by.y=c("chr","start","end"),all.x=T)

ggplot(a2histone, aes(x=factor(V4),y=max)) + geom_boxplot() + scale_y_log10()



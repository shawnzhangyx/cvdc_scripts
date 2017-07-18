setwd("../../analysis/hiccup_loops/")

loop = read.delim("loops_merged_across_samples.uniq.replicated.tab")
dyn = read.delim("replicated_loops.cpb.logFC.edger.dynamic.txt")
a2tss = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)
exp = read.delim("../../data/rnaseq/gene.rpkm.edger.txt")

loop$name=paste(loop$chr1,loop$x1,loop$y1)
loop$a1 = paste(loop$chr1,loop$x1)
loop$a2 = paste(loop$chr1,loop$y1)
loop$dynamic = ifelse(loop$name %in% dyn$name,TRUE, FALSE)
a2tss$name = paste(a2tss$V1,a2tss$V2+10000)
a1 = merge(loop, a2tss, by.x="a1",by.y="name",all.x=TRUE
  )[,c("a1","name","dynamic","V7","V10")]
a2 = merge(loop, a2tss, by.x="a2",by.y="name",all.x=TRUE
  )[,c("a1","name","dynamic","V7","V10")]
  

combined = merge(a1,a2,by="name")

a1.red = aggregate(V10.x~name,combined, 
  function(vec){ sum (ifelse(vec %in% ".", TRUE, FALSE))>0})
a2.red = aggregate(V10.y~name,combined,
  function(vec){ sum (ifelse(vec %in% ".", TRUE, FALSE))>0})
noTss = merge(a1.red,a2.red,by="name")
noTss$dynamic = loop$dynamic[match(noTss$name,loop$name)]
table(noTss$V10.x,noTss$V10.y)
#          FALSE TRUE
#    FALSE  6289 2573
#    TRUE   2502 1780
# 13.5% NoTss  
# 47.8% TSS at both ends. 
# 38.6% TSS at one end. 

allGene = unique(c(as.character(combined$V7.x),as.character(combined$V7.y)))
# 15470
length(which(allGene %in% exp$Geneid[which(exp$fdr<0.05)]))
# 5321
dynamicGene = unique(c(as.character(combined$V7.x[which(combined$dynamic.x==TRUE)]), 
  as.character(combined$V7.y[which(combined$dynamic.y==TRUE)])))
# 5126
length(which(dynamicGene %in% exp$Geneid[which(exp$fdr<0.05)]))
# 1860


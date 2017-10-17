setwd("../../analysis/customLoops")

loop=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loop$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loop$name)
loop$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loop$name)

#anchor = read.delim("overlap_anchors_to_features/anchor.all_features.txt")
#anchor$promoter = anchor$H3K4me3>0 & anchor$H3K27ac>0#| anchor$TSS >0
#anchor$enhancer = anchor$H3K27ac >0 & anchor$H3K4me1 >0

#a1 = anchor[match(loop$a1,paste(anchor$chr,anchor$start+10000)),]
#a2 = anchor[match(loop$a2,paste(anchor$chr,anchor$start+10000)),]

mark = "H3K27ac"
anchor = read.delim(paste0("overlap_anchors_to_features/anchor.",mark,".stages.txt"))
a1 = anchor[match(loop$a1,paste(anchor$chr,anchor$start+10000)),]
a2 = anchor[match(loop$a2,paste(anchor$chr,anchor$start+10000)),]
both = cbind(loop[,c("name","cluster")],a1[,-c(1:3)] * a2[,-c(1:3)])
table(both$cluster,both$D00>0)

agg = aggregate(cbind(D00,D02,D05,D07,D15,D80)~cluster,both,
  FUN=function(vec){ length(which(vec>0))})   

agg2 = sweep(agg[,-1],1,table(both$cluster),'/')



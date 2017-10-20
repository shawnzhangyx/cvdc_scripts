setwd("../../analysis/customLoops")

loop=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loop$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loop$name)
loop$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loop$name)

ctcf = read.table("overlap_anchors_to_features/anchor.CTCF_merged_peaks.txt")
ctcf2 = aggregate(V7~V1+V2+V3,ctcf,FUN=function(vec){length(which(vec!="."))})
a1 = ctcf2[match(loop$a1,paste(ctcf2$V1,ctcf2$V2+10000)),]
a2 = ctcf2[match(loop$a2,paste(ctcf2$V1,ctcf2$V2+10000)),]
both = cbind(loop[,c("name","cluster")],a1[,-c(1:3)] * a2[,-c(1:3)], a1[,-c(1:3)] + a2[,-c(1:3)])
both[,3:4][is.na(both[,3:4])]=0
colnames(both)[3:4] = c("CTCF.prod","CTCF.sum")
agg = aggregate(CTCF.prod~cluster,both,
  FUN=function(vec){ length(which(vec>0))})

agg2 = agg[,-1]/table(both$cluster)

mark = "H3K27ac"
anchor = read.table(paste0("overlap_anchors_to_features/anchor.",mark,"_merged_peaks.txt"))
stage = read.delim(paste0("../../data/chipseq/merged_peaks/",mark,"_merged_peaks.overlap_stage.refined.txt"))
anchor = cbind(anchor,stage[match(anchor$V7,stage$Geneid),-c(1:18)])
anchor = aggregate(cbind(D00.peak,D02.peak,D05.peak,D07.peak,D15.peak,D80.peak)~V1+V2+V3,
  anchor,FUN=sum)
  
a1 = anchor[match(loop$a1,paste(anchor$V1,anchor$V2+10000)),]
a2 = anchor[match(loop$a2,paste(anchor$V1,anchor$V2+10000)),]
both = cbind(loop[,c("name","cluster")],a1[,-c(1:3)] * a2[,-c(1:3)])
#table(both$cluster,both$D00>0)
both[,3:8][is.na(both[,3:8])]=0


agg = aggregate(cbind(D00.peak,D02.peak,D05.peak,D07.peak,D15.peak,D80.peak)~cluster,both,
#  FUN=sum)
  FUN=function(vec){ length(which(vec>0))})

agg2 = sweep(agg[,-1],1,table(both$cluster),'/')


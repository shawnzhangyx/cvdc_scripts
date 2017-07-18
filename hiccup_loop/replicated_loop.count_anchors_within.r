setwd("../../analysis/hiccup_loops")

loops = read.delim("loops_merged_across_samples.uniq.replicated.tab")
anchors = read.delim("replicated_loops/loop_anchors.uniq.30k.bed",header=F)
anchors$start = anchors$V2+10000
dyn = read.delim("replicated_loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
#anchors$end   = anchors$V3-10000
loops$Length = loops$y1-loops$x1 

findAnchor = function(loop, anchor){
  tmp = length(which(anchor$V1 == loop$chr1 & anchor$start >= loop$x1 & anchor$start <= loop$y1))
  tmp-1
  }
DegreeOfAnchors = sapply(1:nrow(loops), function(x){ findAnchor(loops[x,],anchors)})
loops$DegreeOfAnchors = DegreeOfAnchors

write.table(loops,"replicated_loops/loops.DegreeOfAnchors.tab",quote=F,row.names=F,sep='\t')
loops$Length = loops$y1-loops$x1
loops$name = paste(loops$chr1,loops$x1,loops$y1)
loops$cluster = dyn$cluster[match(loops$name,dyn$name)]
loops$cluster[is.na(loops$cluster)] = 0

ylim1 = boxplot.stats(subset(loops, Length<5e6)$DegreeOfAnchors)$stats[c(1, 5)]

ggplot(subset(loops, Length <5e6) , aes(x=factor(cluster),y=DegreeOfAnchors)) + 
  geom_boxplot(outlier.color="NA") + coord_cartesian(ylim = ylim1*1.05)




setwd("../../analysis/hiccup_loops/")

anchors = read.delim("loop_anchors.uniq.30k.num_loops.dedup.txt",header=F)
anchors$name = paste(anchors$V1,anchors$V2+10000)
loops = read.delim("loops.cpb.logFC.edger.dynamic.cluster.txt")
loops$a1 = paste(loops$chr,loops$x1)
loops$a2 = paste(loops$chr,loops$y1)
a1 = data.frame(loops$a1,loops$cluster)
a2 = data.frame(loops$a2,loops$cluster)
colnames(a1) = colnames(a2) = c("name","cluster")
combined = rbind(a1,a2)
agg = aggregate(cluster~name, combined, function(vec){paste(sort(vec),collapse=",")})

anchors2 = merge(anchors,agg,by="name",all.x=T)

tss = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)
tss.agg = aggregate(V7~V1+V2+V3, tss, function(vec){paste(sort(unique(vec)),collapse=",")})

anchors3 = merge(anchors2[,-1],tss.agg, by=c("V1","V2","V3"))
anchors3 = anchors3[order(-anchors3$V4),]

colnames(anchors3) = c("chr","start","end","degree","cluster","genes")
write.table(anchors3, "anchors/loop_anchors.uniq.30k.dedup.cluster.gene.txt",row.names=F,sep='\t',quote=F)

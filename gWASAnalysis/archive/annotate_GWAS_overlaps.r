setwd("../../analysis/gWAS")

a1 = read.delim("gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.overlap_hiccup_anchor1.txt",header=F)
a2 = read.delim("gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.overlap_hiccup_anchor2.txt",header=F)
a1$name = paste(a1$V11,a1$V12,a1$V15)
a1$anch = paste(a1$V14,a1$V15)
a2$name = paste(a2$V11,a2$V15,a2$V12)
a2$anch = paste(a2$V14,a2$V15)

loop = read.delim("../hiccup_loops/loops/loops.cpb.logFC.edger.final.txt")
dyn = read.delim("../hiccup_loops/loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
anch = read.delim("../hiccup_loops/overlap_anchors_to_features/anchor.gene_tss.unique.txt",
header=F)
anch$anch = paste(anch$V1,anch$V2+10000)
anch = anch[which(anch$anch %in% c(a1$anch,a2$anch)),]
anch.agg = aggregate(V7~anch, data=anch, function(vec){ paste(sort(unique(vec)),collapse=",")})

reads = (loop[,seq(2,13,2)] + loop[,seq(3,13,2)])/2

out1 = cbind(loop[,c("name","dynamic")],reads)[match(a1$name,loop$name),]
out1$cluster = dyn$cluster[match(a1$name,dyn$name)]
out1$gene = anch.agg$V7[match(a1$anch,anch.agg$anch)]

out2 = cbind(loop[,c("name","dynamic")],reads)[match(a2$name,loop$name),]
out2$cluster = dyn$cluster[match(a2$name,dyn$name)]
out2$gene = anch.agg$V7[match(a2$anch,anch.agg$anch)]


out1f = cbind(a1[,c(1:9)],out1)
out2f = cbind(a2[,c(1:9)],out2)
colnames(out1f) = colnames(out2f) = c("ATAC.chr","ATAC.start","ATAC.stop","ATAC.name",
  "snp.chr","snp.start","snp.end","snp.name","snp.trait","loop.name","dynamic",
  "D00","D02","D05","D07","D15","D80","cluster","gene")
write.table(out1f,"gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.overlap_hiccup_anchor1.details.txt",row.names=F,quote=F,sep='\t')
write.table(out2f,"gWAS.overlap_atac_distal.uniq.overlap_H3K27ac_peaks.overlap_hiccup_anchor2.details.txt",row.names=F,quote=F,sep='\t')



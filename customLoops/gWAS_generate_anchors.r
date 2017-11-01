setwd("../../analysis/customLoops")

anchors = read.table("anchors/anchors.uniq.bed")
loops = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt")

loops$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loops$name)
loops$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loops$name)
anchors$name = paste(anchors$V1,anchors$V2)

loops25 = loops[which(loops$cluster>1),]
out25 = anchors[which(anchors$name %in% c(loops25$a1,loops25$a2)),]
out25$V2 = out25$V2-10000
out25$V3 = out25$V3+10000

loops35 = loops[which(loops$cluster>2),]
out35 = anchors[which(anchors$name %in% c(loops35$a1,loops35$a2)),]
out35$V2 = out35$V2-10000
out35$V3 = out35$V3+10000


write.table(out25[,1:3],"gWAS/anchors.clusters2-5.bed",row.names=F,col.names=F,sep='\t',quote=F)
write.table(out35[,1:3],"gWAS/anchors.clusters3-5.bed",row.names=F,col.names=F,sep='\t',quote=F)


### nondynamic loops
nondyn = read.delim("loops/loops.cpb.logFC.edger.nondynamic.txt")
anchors = read.table("anchors/anchors.uniq.bed")
nondyn$a1 = sub("(.*) (.*) (.*)","\\1 \\2",nondyn$name)
nondyn$a2 = sub("(.*) (.*) (.*)","\\1 \\3",nondyn$name)
anchors$name = paste(anchors$V1,anchors$V2)
out_nondyn = anchors[which(anchors$name %in% c(nondyn$a1,nondyn$a2)),]
out_nondyn$V2 = out_nondyn$V2-10000
out_nondyn$V3 = out_nondyn$V3+10000

write.table(out_nondyn[,1:3],"gWAS/anchors.nondynamic.bed",row.names=F,col.names=F,sep='\t',quote=F)


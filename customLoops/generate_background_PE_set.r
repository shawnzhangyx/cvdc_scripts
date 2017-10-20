setwd("../../analysis/customLoops")
loop=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loop$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loop$name)
loop$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loop$name)

H3K4me3 = read.table("overlap_anchors_to_features/anchor.H3K4me3_merged_peaks.txt")
prom = aggregate(V7~V1+V2+V3,H3K4me3,FUN=function(vec){length(which(vec!="."))})
colnames(prom) = c("V1","V2","V3","H3K4me3")
a1 = prom[match(loop$a1,paste(prom$V1,prom$V2+10000)),]
a2 = prom[match(loop$a2,paste(prom$V1,prom$V2+10000)),]

H3K4me1 = read.table("overlap_anchors_to_features/anchor.H3K4me1_merged_peaks.txt")
enh = aggregate(V7~V1+V2+V3,H3K4me1,FUN=function(vec){length(which(vec!="."))})
a1$H3K4me1 = enh$V7[match(loop$a1, paste(enh$V1,enh$V2+10000))]
a2$H3K4me1 = enh$V7[match(loop$a2, paste(enh$V1,enh$V2+10000))]

a1$PE = "U"
a1$PE[which(a1$H3K4me3>0)] = "P"
a1$PE[which(a1$H3K4me3==0 & a1$H3K4me1>0)] = "E"
a2$PE = "U"
a2$PE[which(a2$H3K4me3>0)] = "P"
a2$PE[which(a2$H3K4me3==0 & a2$H3K4me1>0)] = "E"


set1 = cbind(a1[,c(1,2)],a2[,2])[which(a1$PE=="P"),]
set1[,2:3] = set1[,2:3]+10000
set1$alt = set1[,2]*2-set1[,3]
set1 = set1[,c(1,4,2)]

set2 = cbind(a1[,c(1,2)],a2[,2])[which(a2$PE=="P"),]
set2[,2:3] = set2[,2:3]+10000
set2$alt = set2[,3]*2-set2[,2]
set2 = set2[,c(1,3,4)]

anchors = rbind(set1[,c(1,2)],set2[,c(1,3)])



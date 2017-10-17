setwd("../../analysis/customLoops")

loop = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
loop = loop[which(loop$cluster %in% c(3,4)),]
loop$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loop$name)
loop$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loop$name)
#contacts = loop[,seq(2,13,2)]+loop[,seq(3,13,2)]
contacts = loop[,14:18]

#l2 = read.delim("combined_loops.uniq.gt1.txt")
over = read.delim("overlap_anchors_to_features/anchor.atac_merged_peaks.txt",header=F)
over$name = paste(over$V1,over$V2+10000)
atac1 = over[which(over$name %in% c(loop$a1,loop$a2)),]

peaks = data.frame(fread("../../data/atac/peaks/atac_merged_peaks.overlap_stage.txt"))

atac2 = cbind(peaks[match(atac1$V7,peaks$V4),],atac1$name)
# ATAC seq peaks that are gained. 
atac3 = atac2[which(rowSums(atac2[,5:9])==0 & atac2[,10]>0),]


m1 = match(atac3$"atac1$name",loop$a1)
m2 = match(atac3$"atac1$name",loop$a2)

atac4 = cbind(atac3,loop$name[ifelse(is.na(m1),m2,m1)], contacts[ifelse(is.na(m1),m2,m1),])
colnames(atac4)[11:12]=c("anchor","loop")

atac5 = atac4[which(atac4$logFC.D80.D15 < -0.5),]
atac5$dist = as.numeric(sub("(.*) (.*) (.*)","\\3",atac5$loop)) -
  as.numeric(sub("(.*) (.*) (.*)","\\2",atac5$loop))

atac5 = atac5[order(atac5$dist),]
colnames(atac5)[1:10] = c("chr",'start','end','atacPeak.name','ATAC.D00','ATAC.D02','ATAC.D05','ATAC_D05','ATAC_D15','ATAC_D80')

write.table(atac5, "test.overlap_loop.atac.inverse_switch",row.names=F,sep='\t',quote=F)


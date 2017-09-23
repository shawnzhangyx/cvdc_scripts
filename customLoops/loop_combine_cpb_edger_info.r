setwd("../../analysis/customLoops/")
# edgeR test
all = read.delim("edgeR/loops_edgeR_test_allStage.txt")
# contact count per billion
cpb = read.delim("edgeR/loops_cpb.txt")
# loop
all$name = paste(all$chr,all$x1,all$y1)
cpb$name = rownames(cpb)
combined = merge(cpb,all,by="name")
combined = combined[,-c(14,15,16)]
combined$dynamic = combined$fdr<0.01

write.table(combined,"loops/loops.cpb.logFC.edger.final.txt",
  quote=F,sep='\t',row.names=F)
write.table(combined[combined$dynamic==TRUE,],"loops/loops.cpb.logFC.edger.dynamic.txt",
  quote=F,sep='\t',row.names=F)
write.table(combined[!combined$dynamic==TRUE,],"loops/loops.cpb.logFC.edger.nondynamic.txt",
  quote=F,sep='\t',row.names=F)



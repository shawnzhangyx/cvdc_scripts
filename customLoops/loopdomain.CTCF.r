setwd("../../analysis/customLoops/")

a=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
b=read.table("overlap_loopdomain_to_features/domain.CTCF_merged_peaks.txt")
d=read.delim("../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.overlap_stage.refined.txt")

ctcf = cbind(b,d[match(b$V7,d$Geneid),])
ctcf$name = paste(ctcf$V1,ctcf$V2,ctcf$V3)

agg = aggregate(cbind(D00.peak,D02.peak,D07.peak,D15.peak)~name,data=ctcf,sum)

out = cbind(a[,c(1,24)],agg[match(a$name,agg$name),-1])

c4 = out[which(out$cluster==4),]
boxplot(c4[,3:6])

c2 = out[which(out$cluster==2),]
boxplot(c2[,3:6])

c1 = out[which(out$cluster==1),]
boxplot(c1[,3:6])
c0 = out[which(out$cluster==0),]
boxplot(c0[,3:6])


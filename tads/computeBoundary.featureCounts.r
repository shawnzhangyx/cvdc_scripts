setwd("../../analysis/tads")

mark = "CTCF"
## RNA-seq 
anchor = read.delim(paste0("overlap_anchors_to_features/anchor.CTCF_merged_peaks.txt"),header=F)
counts = data.frame(fread("../../data/tfChIPseq/counts/CTCF.counts"))
colnames(counts)[-c(1:6)] = sub("bam.(.*D.._Rep.).*.bam","\\1",colnames(counts)[-c(1:6)])
sums = colSums(counts[,-c(1:6)])
counts[,-c(1:6)] = sweep(counts[,-c(1:6)],2,sums,'/')*1e6

m = merge(anchor,counts, by.x="V7",by.y="Geneid",all.x=T)
m[,c(15:25)][is.na(m[,c(15:25)])] = 0

agg = aggregate(.~V1+V2+V3, m[,c(2:4,15:25)],sum)
rep1 = agg[,c(seq(4,13,2),14)]
rep2 = agg[,c(seq(5,13,2),14)]
ave = cbind(agg[,1:3],(rep1+rep2)/2)
colnames(ave) = c("chr","start","end",paste0(mark,c("_D00","_D02","_D05","_D07","_D15","_D80")))
write.table(ave,paste0("overlap_anchors_to_features/anchor.CTCF.norm_counts.txt"),quote=F,sep='\t',row.names=F)

#mf = m[which(m$V9=="+"),]
#agg = aggregate(.~V1+V2+V3, mf[,c(2:4,15:22)],sum)
#rep1 = agg[,seq(4,11,2)]
#rep2 = agg[,seq(5,11,2)]
#ave = cbind(agg[,1:3],(rep1+rep2)/2)
#colnames(ave) = c("chr","start","end",paste0(mark,c("_D00","_D02","_D07","_D15")))
#write.table(ave,paste0("overlap_anchors_to_features/anchor.CTCF.f.norm_counts.txt"),quote=F,sep='\t',row.names=F)
#
#
#mr = m[which(m$V9=="-"),]
#agg = aggregate(.~V1+V2+V3, mr[,c(2:4,15:22)],sum)
#rep1 = agg[,seq(4,11,2)]
#rep2 = agg[,seq(5,11,2)]
#ave = cbind(agg[,1:3],(rep1+rep2)/2)
#colnames(ave) = c("chr","start","end",paste0(mark,c("_D00","_D02","_D07","_D15")))
#write.table(ave,paste0("overlap_anchors_to_features/anchor.CTCF.r.norm_counts.txt"),quote=F,sep='\t',row.names=F)

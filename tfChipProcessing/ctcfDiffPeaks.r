setwd("../../data/tfChIPseq/")

a=read.delim("merged_peaks/CTCF_merged_peaks.overlap_stage.txt",header=F)
b=read.delim("edger/CTCF.rpkm.fc.edger.txt")

a[,5:10] = a[,5:10]>0

a$qBH = b$qBH[match(a$V4,b$Geneid)]
a$bonf = b$bonf[match(a$V4,b$Geneid)]

qBH = aggregate(cbind(V5,V6,V7,V8,V9,V10)~ (qBH<0.05),a,sum)
bonf = aggregate(cbind(V5,V6,V7,V8,V9,V10)~ (bonf<0.05),a,sum)

diff = a[which(a$bonf<0.05),]

diff = diff[order(diff$V5,diff$V6,diff$V7,diff$V8,diff$V9,diff$V10),]
diff$V4 = factor(diff$V4,levels=diff$V4)
melted = melt(diff[,4:10],id.vars="V4")

ggplot(melted,aes(x=variable,y=V4,fill=value)) + geom_tile()



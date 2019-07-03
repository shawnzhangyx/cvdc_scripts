setwd("../../analysis/tads/stage_specific_tads")

a=read.delim("D00.unique.tads",header=F)

b1 = a
b1$V2 = b1$V2-25000
b1$V3 = b1$V2+50000

b2 = a
b2$V2 = b2$V3-25000
b2$V3 = b2$V2+50000

out = rbind(b1,b2)
write.table(out, "D00.unique.tad_boundary.txt",row.names=F,col.names=F,sep='\t',quote=F)


a$V2 = a$V2-25000
a$V3 = a$V3+25000

write.table(a, "D00.unique.tads.inc25k.bed",row.names=F,col.names=F,sep='\t',quote=F)



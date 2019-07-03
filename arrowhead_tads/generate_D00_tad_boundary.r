setwd("../../analysis/tads/")

a = read.delim("combined_tads.uniq.gt1.txt")

b= a[grep("D00",a$samples),]

b1 = b[,c(1,2)]
b2 = b[,c(1,3)]
colnames(b2)  = colnames(b1)

out = rbind(b1,b2)
out = out[!duplicated(out),]
out = out[order(out$chr1,out$x1),]
out$x2 = out$x1+10000
write.table(out,"tad_boundary/D00.boundary.bed",row.names=F,col.names=F,quote=F,sep='\t')

## stage specific tads. 
b=read.table("stage_specific_tads/D00.unique.tads")

b1 = b[,c(1,2)]
b2 = b[,c(1,3)]
colnames(b2)  = colnames(b1)

out = rbind(b1,b2)
#out = out[!duplicated(out),]
#out = out[order(out$chr1,out$x1),]
out$V3 = out$V2+10000
write.table(out,"tad_boundary/D00.specific.boundary.bed",row.names=F,col.names=F,quote=F,sep='\t')


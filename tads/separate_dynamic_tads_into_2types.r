setwd("../../analysis/tads")
a=read.delim("combined_tads.uniq.score.sig.diff.txt")

d00 = a[which(a$D00==TRUE & rowSums(a[,4:9])==1),]
d80 = a[which(a$D80==FALSE & rowSums(a[,4:9])==5),]
gain = a[which(a$D00==FALSE & a$D80==TRUE),]


write.table(d00[,1:3],"stage_specific_tads/D00.unique.tads",row.names=F,col.names=F,sep='\t',quote=F)
write.table(d80[,1:3],"stage_specific_tads/D80.unique.tads",row.names=F,col.names=F,sep='\t',quote=F)
write.table(gain[,1:3],"stage_specific_tads/gain.unique.tads",row.names=F,col.names=F,sep='\t',quote=F)

#d00.pre = d00[,1:3]
#d00.pre$dist = d00.pre$x2-d00.pre$x1
#d00.pre$x2=d00.pre$x1
#d00.pre$x1=d00.pre$x1-d00.pre$dist
#write.table(d00.pre[,1:3],"D00.pre.tads",row.names=F,col.names=F,sep='\t',quote=F)
#
#d00.pos = d00[,1:3]
#d00.pos$dist = d00.pos$x2-d00.pos$x1
#d00.pos$x1=d00.pos$x2
#d00.pos$x2=d00.pos$x2+d00.pos$dist
#write.table(d00.pos[,1:3],"D00.pos.tads",row.names=F,col.names=F,sep='\t',quote=F)
#
#
#d80.pre = d80[,1:3]
#d80.pre$dist = d80.pre$x2-d80.pre$x1
#d80.pre$x2=d80.pre$x1
#d80.pre$x1=d80.pre$x1-d80.pre$dist
#write.table(d80.pre[,1:3],"D80.pre.tads",row.names=F,col.names=F,sep='\t',quote=F)
#
#d80.pos = d80[,1:3]
#d80.pos$dist = d80.pos$x2-d80.pos$x1
#d80.pos$x1=d80.pos$x2
#d80.pos$x2=d80.pos$x2+d80.pos$dist
#write.table(d80.pos[,1:3],"D80.pos.tads",row.names=F,col.names=F,sep='\t',quote=F)
#

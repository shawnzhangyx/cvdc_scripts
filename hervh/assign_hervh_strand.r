a=read.delim("hervh_beds/hervh.merged.overlap_orig.tmp")

agg = aggregate(V9~V4+V8,a,sum)
agg = agg[order(-agg$V9),]
agg = agg[!duplicated(agg$V4),]

b = cbind(a[match(agg$V4,a$V4),1:3],agg$V4,".",agg$V8)
write.table(b,"hervh.merged.strand.bed",row.names=F,col.names=F,quote=F,sep='\t')


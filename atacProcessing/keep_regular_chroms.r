data = read.delim(file("stdin"),header=F)
chrs = paste0("chr",c(1:22,"X"))
out = data[which(data$V1 %in% chrs),]
write.table(out, "",row.names=F,col.names=F,sep='\t',quote=F)


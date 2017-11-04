setwd("../../data/rnaseq/")
rpkm = data.frame(fread("rerun/combined-chrM.rpkm"))
genetype = data.frame(fread("../annotation/gencode.gene.type.txt",header=F))

rpkm$type = genetype$V2[match(rpkm$Geneid,genetype$V1)]

rpkm = rpkm[,c(1,6,19,7:18)]
colnames(rpkm)[4:15] = sub(".*(D.._.)\\.nodup.bam","\\1",colnames(rpkm)[4:15])
colnames(rpkm)[4:15] = sub(".*D(._.)\\.nodup.bam","D0\\1",colnames(rpkm)[4:15])

rpkm2 = cbind(rpkm[,c(1:3)],rpkm[,3+order(colnames(rpkm)[4:15])])
write.table(rpkm2,"gene.rpkm.type.txt",row.names=F,sep='\t',quote=F)

rpkm3 = rpkm2[which(rowSums(rpkm2[,4:15])>0),]
write.table(rpkm3,"gene.rpkm.expressed.type.txt",row.names=F,sep='\t',quote=F)



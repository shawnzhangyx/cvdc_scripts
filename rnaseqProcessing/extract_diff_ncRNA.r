setwd("../../data/rnaseq")

#a=read.delim("gene.rpkm.cluster.txt")
a=read.delim("gene.rpkm.edger.txt")
b=read.delim("../annotation/gencode.gene.type.txt",header=F)
a$type = b$V2[match(a$Geneid,b$V1)]

write.table(a[which(a$type!="protein_coding"),],"gene.rpkm.edger.noncoding.txt",row.names=F,sep='\t',quote=F)


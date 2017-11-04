setwd("../../data/annotation/")
ann = data.frame(fread("~/annotations/hg19/gencode.v19.annotation.gtf"))
get_gene_type = function(obj){
temp = sub('.* gene_type "(.*?)".*','\\1',obj)
temp
}

get_gene_symbol = function(obj){
temp = strsplit(obj,";")[[1]][5]
gene_name = strsplit(temp,"\"")[[1]][2]
gene_name
}

exon=ann[which(ann$V3=="exon"),]
exon$symbol = sapply(exon$V9,get_gene_symbol)
exon$type = sapply(exon$V9,get_gene_type)

genetype = exon[,c(10,11)]
genetype = genetype[!duplicated(genetype),]

write.table(genetype,"gencode.gene.type.txt",row.names=F,col.names=F,sep='\t',quote=F)


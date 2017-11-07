setwd("../../analysis/gWAS_customLoop")
a=read.delim("anchors.overlap_genes.all.txt",stringsAsFactors=F)
rpkm = read.delim("../../data/rnaseq/gene.rpkm.expressed.type.txt")

gene = NULL
for (i in 1:nrow(a)){
    if ( a$gene[i] != "." ){
gene = c(gene,strsplit(a$gene[i],",")[[1]])
} }

out = gene[which(gene %in% rpkm$Geneid[which( apply(rpkm[,4:15],1,max)>5)])]
write.table(gene,"genes.txt",row.names=F,col.names=F,quote=F)
#write.table(out,"test",row.names=F,quote=F)

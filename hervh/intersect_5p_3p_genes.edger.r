rna = data.frame(fread('../../data/rnaseq/gene.rpkm.edger.txt'))
rna$D00 = (rna$D00_1+rna$D00_2)/2
rna$D02 = (rna$D02_1+rna$D02_2)/2

a=unique(read.delim("hervh_regulated_gene_TADs/5p_TAD.overlap_genes.txt",header=F,stringsAsFactors=F)$V7)
m1 = rna[which(rna$Geneid %in% a),]

b=unique(read.delim("hervh_regulated_gene_TADs/3p_TAD.overlap_genes.txt",header=F,stringsAsFactors=F)$V7)
m2= rna[which(rna$Geneid %in% b),]


write.table(m1$Geneid,"hervh_regulated_gene_TADs/hervh_5associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)
write.table(m2$Geneid,"hervh_regulated_gene_TADs/hervh_3associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)


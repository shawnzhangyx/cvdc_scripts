setwd("../../analysis/hervh/hervh_regulated_gene_TADs")
a=readLines("hervh_5associated_genes.txt")
b=readLines("hervh_3associated_genes.txt")

seq = read.delim("../../../data/rnaseq/gene.rpkm.edger.txt")
#seq.a = seq[which(seq$Geneid %in% a),c("Geneid","D00_1")]


x=read.delim("../../../data/Wang_etal_2014_Nature/shHERVH.exp.txt",stringsAsFactors=F)
#x$qvalue = p.adjust(x$P.Value,method="BH",n=2e4)
y=read.delim("../../../data/Wang_etal_2014_Nature/shLBP9.exp.txt",stringsAsFactors=F)
#y$qvalue = p.adjust(y$P.Value,method="BH",n=2e4)


x.5 = x[which(x$gene %in% a),]
x.5 = x.5[order(x.5$P.Value),]
x.5 = x.5[!duplicated(x.5$gene),]
x.5$D0.rpkm = seq$D00_1[match(x.5$gene,seq$Geneid)]


x.3 = x[which(x$gene %in% b),]
x.3 = x.3[order(x.3$P.Value),]
x.3 = x.3[!duplicated(x.3$gene),]
x.3$D0.rpkm = seq$D00_1[match(x.3$gene,seq$Geneid)]


y.5 = y[which(y$gene %in% a),]
y.5 = y.5[order(y.5$P.Value),]
y.5 = y.5[!duplicated(y.5$gene),]
y.5$D0.rpkm = seq$D00_1[match(y.5$gene,seq$Geneid)]

y.3 = y[which(y$gene %in% b),]
y.3 = y.3[order(y.3$P.Value),]
y.3 = y.3[!duplicated(y.3$gene),]
y.3$D0.rpkm = seq$D00_1[match(y.3$gene,seq$Geneid)]


setwd("../../analysis/ab_compartments/compartmentSwitches")

a = read.table("anyStage.switch.overlap_gene.bed")
a = a[,c(4,7,8:16)]

b= read.delim("../../../data/rnaseq/gene.rpkm.edger.txt")
b = data.frame(Gene=b$Geneid,b[,seq(4,9,1)]+b[,seq(10,15,1)])
#b = read.delim("../../../data/rnaseq/gene.rpkm.txt")
#b = data.frame(Gene=b$Annotation.Divergence,b[,seq(2,13,2)]+b[,seq(3,13,2)])

d = merge(a,b,by.x="V4",by.y="Gene")

cor = sapply(1:nrow(d),function(i){ 
  cor.test( as.numeric(d[i,6:11]), as.numeric(d[i,12:17]),method="pearson")$ estimate })

d$cor = cor
e = d[order(-d$cor),]
e = e[!duplicated(d$V4),]

pdf("correlation_of_AB_gene.pdf",height=4,width=4)
#boxplot(e$cor,col=cbbPalette[6])
ggplot(e, aes(cor)) + geom_histogram(fill=cbbPalette[6]) + 
  xlab("Pearson Correlation") + ylab("Number of Genes") + 
  theme_bw()

dev.off()


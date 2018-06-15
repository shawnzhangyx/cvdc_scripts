setwd("../../analysis/hervh/")

rna = data.frame(fread('../../data/rnaseq/gene.rpkm.edger.txt'))

a=unique(read.delim("hervh_regulated_gene_TADs/5p_TAD.overlap_genes.txt",header=F,stringsAsFactors=F)$V7)
m1 = rna[which(rna$Geneid %in% a),]


b=unique(read.delim("hervh_regulated_gene_TADs/3p_TAD.overlap_genes.txt",header=F,stringsAsFactors=F)$V7)
m2= rna[which(rna$Geneid %in% b),]

#ggplot(m1) + geom_point(aes(x=logCPM,y=logFC.D02.D00)) #,color=fdr<0.05))
#ggplot(m2) + geom_point(aes(x=logCPM,y=logFC.D02.D00)) #,color=fdr<0.05))

mm1 = melt(m1[,c(1,4,5)])
mm1$type="p5"
mm2 = melt(m2[,c(1,4,5)])
mm2$type="p3"

comb= rbind(mm1,mm2)
comb$type = factor(comb$type,c("p5","p3"))


pdf("figures/regulated_genes_on_5p3p_of_HERVH.pdf",height=4,width=4)
ggplot(comb) + geom_boxplot(aes(x=type,fill=variable,y=value)) +
  annotate(geom="text",x=c(1,2),y=c(100,100),label=c("p=0.007","p=0.39"))+
  xlab("") + ylab("RPKM") + 
  scale_y_log10(breaks=c(0.1,1,10,100)) +
  scale_x_discrete(labels=c("5'LTR (N=58)","3'LTR (N=51)")) + 
  theme( 
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )
dev.off()

write.table(m1$Geneid,"hervh_regulated_gene_TADs/hervh_5associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)
write.table(m2$Geneid,"hervh_regulated_gene_TADs/hervh_3associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)

write.table(c(m1$Geneid,m2$Geneid),"hervh_regulated_gene_TADs/hervh_associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)


#ggplot(comb) + geom_line(aes(x=variable,y=log2(value),group=Geneid)) + 
#  facet_grid(.~type)
t.test(x=log(m1$D00_1+1),y=log(m1$D02_1+1),paired=T)
# 0.007343

t.test(x=log(m2$D00_1+1),y=log(m2$D02_1+1),paired=T)
# p= 0.3932

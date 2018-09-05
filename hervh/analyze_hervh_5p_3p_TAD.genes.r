setwd("../../analysis/hervh/")

rna = data.frame(fread('../../data/rnaseq/gene.rpkm.edger.txt'))
rna$D00 = (rna$D00_1+rna$D00_2)/2
rna$D02 = (rna$D02_1+rna$D02_2)/2

#a=unique(read.delim("hervh_regulated_gene_TADs/5p_TAD.overlap_genes.txt",header=F,stringsAsFactors=F)$V7)
 a = readLines("hervh_regulated_gene_TADs/hervh_5associated_genes.v2.txt")
m1 = rna[which(rna$Geneid %in% a),]


#b=unique(read.delim("hervh_regulated_gene_TADs/3p_TAD.overlap_genes.txt",header=F,stringsAsFactors=F)$V7)
 b = readLines("hervh_regulated_gene_TADs/hervh_3associated_genes.v2.txt")
m2= rna[which(rna$Geneid %in% b),]

#ggplot(m1) + geom_point(aes(x=logCPM,y=logFC.D02.D00)) #,color=fdr<0.05))
#ggplot(m2) + geom_point(aes(x=logCPM,y=logFC.D02.D00)) #,color=fdr<0.05))

mm1 = melt(m1[,c(1,25,26)])
mm1$type="p5"
mm2 = melt(m2[,c(1,25,26)])
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

MM=0.1
ggplot() + geom_point(data=rna, aes(x=D00+MM,y=D02+MM),color='gray') +
  geom_abline(intercept=0,slope=1) +
  #  stat_bin_2d(data=cpm2, aes(x=Human+MM,y=Marmoset+MM),binwidth=c(10,10)) +
  geom_point(data=m2, aes(x=D00+MM,y=D02+MM),color='red') +
  geom_point(data=m1, aes(x=D00+MM,y=D02+MM),color='blue') +
  scale_y_log10() + scale_x_log10()
  xlim(0,100) + ylim(0,100)

dev.off()

#write.table(m1$Geneid,"hervh_regulated_gene_TADs/hervh_5associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)
#write.table(m2$Geneid,"hervh_regulated_gene_TADs/hervh_3associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)

#write.table(c(m1$Geneid,m2$Geneid),"hervh_regulated_gene_TADs/hervh_associated_genes.txt",row.names=F,col.names=F,sep='\t',quote=F)


#ggplot(comb) + geom_line(aes(x=variable,y=log2(value),group=Geneid)) + 
#  facet_grid(.~type)
t.test(x=log(m1$D00+1),y=log(m1$D02+1),paired=T)
# 0.007343

t.test(x=log(m2$D00+1),y=log(m2$D02+1),paired=T)
# p= 0.3932

wilcox.test(x=log(m1$D00+1),y=log(m1$D02+1),paired=T)

wilcox.test(x=log(m2$D00+1),y=log(m2$D02+1),paired=T)


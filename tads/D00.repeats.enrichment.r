setwd("../../analysis/tads/stage_specific_tads")

a=read.table("D00.boundary.repeats_counts.txt")

## Name D00 D80 D00-random all

#a$V4=a$V4/10
a$P1 = a$V2/354
a$P2 = a$V5/12196
a$FC = a$V2/354/a$V5*12196
a$pval = 1
for (i in 1:nrow(a)){
#test = matrix(c(a[i,2],354-a[i,2],a[i,5],12196-a[i,5]),ncol=2,byrow=T)
test = matrix(c(a[i,2],354-a[i,2],a[i,5]-a[i,2],12196-354-a[i,5]+a[i,2]),ncol=2,byrow=T)

a$pval[i] = prop.test(test,alternative="g")$p.value
}
a$fdr = p.adjust(a$pval,method="bonferroni")
a= a[order(a$FC),]
write.table(subset(a, FC>2 & fdr<0.001)$V1,"D00.enriched_repeats.txt",row.names=F,col.names=F,sep='\t',quote=F)


b = read.table("D00.boundary.repeats_counts.txt")
b$P1 = b$V3/302
b$P2 = b$V5/12196
b$FC = b$V3/302/b$V5*12196
b$pval = 1
for (i in 1:nrow(b)){
#test = matrix(c(b[i,2],354-b[i,2],b[i,5],12196-b[i,5]),ncol=2,byrow=T)
test = matrix(c(b[i,3],302-b[i,3],b[i,5]-b[i,3],12196-302-b[i,5]+b[i,3]),ncol=2,byrow=T)
b$pval[i] = prop.test(test,alternative="g")$p.value
}
b$fdr = p.adjust(b$pval,method="bonferroni")
b= b[order(b$fdr),]


library(ggrepel)
pdf("repeats_enrichment_scatter.pdf",height=4,width=4)
ggplot() +
   geom_label_repel(data=subset(a,FC>2 & fdr<0.001), aes(x=FC,y=-log10(fdr),label=V1),size=5) + 
   geom_jitter(data=a,aes(x=FC,y=-log10(fdr),color="ES+"),alpha=1) + 
   geom_jitter(data=b,aes(x=FC,y=-log10(fdr),color="CM-"),alpha=0.5) +
   xlab("Fold Enrichment") + ylab("-log10 bonferroni p-value") +
   theme_bw() + 
   theme(legend.position="top",
    axis.text.x = element_text(face="bold"),
    axis.text.y = element_text(face="bold"),
    )
dev.off()

pdf("repeats_enrichment_bar.pdf",height=4,width=3)
ggplot(data=subset(a,FC>2 & fdr<0.001)) +   
  geom_bar(aes(x=as.numeric(factor(V1))-0.2,y=P1,fill="ES+"),stat="identity",width=0.5) + 
  geom_bar(aes(x=as.numeric(factor(V1))+0.2,y=P2,fill="Control"),stat="identity",width=0.5) + 
  scale_x_continuous(breaks=1:7,labels=as.character(levels(factor(subset(a,FC>2 & fdr<0.001)$V1)))) +
  scale_fill_manual(values=c("grey","red")) + 
  xlab("") + ylab("Fraction") +theme_bw() + 
  theme(axis.text.x = element_text(angle=45,hjust=1,size=13,face="bold"),
  legend.position="top")
dev.off()


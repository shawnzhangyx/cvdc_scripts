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

library(ggrepel)
pdf("repeats_enrichment.pdf",height=5,width=5)
  ggplot() +
   geom_point(data=a,aes(x=FC,y=-log10(fdr))) + 
   geom_label_repel(data=subset(a,FC>2 & fdr<0.001), aes(x=FC,y=-log10(fdr),label=V1)) + 
   xlab("Fold Enrichment") + ylab("-log10 bonferroni p-value") +
   theme_bw()
## plot only the HERVH.
# ggplot() +  
#  geom_bar( aes(x=c("ES-specific","Other"),y=c(34/354,(473-34)/(12196-354))), 
#  stat="identity",position="dodge") + 
#  xlab("") + ylab("Proportion") + theme_bw()
## plot the top 
  ggplot(data=subset(a,FC>2 & fdr<0.001)) +   
  geom_bar(aes(x=as.numeric(factor(V1))-0.2,y=P1),fill="red",stat="identity",width=0.5) + 
  geom_bar(aes(x=as.numeric(factor(V1))+0.2,y=P2),fill="grey",stat="identity",width=0.5) + 
  scale_x_continuous(breaks=1:7,labels=as.character(levels(factor(subset(a,FC>2 & fdr<0.001)$V1)))) +
  xlab("") + ylab("Fraction") +theme_bw() + 
  theme(axis.text.x = element_text(angle=45,hjust=1))

dev.off()

a = read.table("D00.boundary.repeats_counts.txt")

a$P1 = a$V3/302
a$P2 = a$V5/12196
a$FC = a$V3/302/a$V5*12196
a$pval = 1
for (i in 1:nrow(a)){
#test = matrix(c(a[i,2],354-a[i,2],a[i,5],12196-a[i,5]),ncol=2,byrow=T)
test = matrix(c(a[i,3],302-a[i,3],a[i,5]-a[i,3],12196-302-a[i,5]+a[i,3]),ncol=2,byrow=T)

a$pval[i] = prop.test(test,alternative="g")$p.value
}
a$fdr = p.adjust(a$pval,method="bonferroni")

a= a[order(a$fdr),]



setwd("../../analysis/hervh/")

p5 = read.delim("hervh_regulated_gene_TADs/hervh_5associated_genes.v2.txt",header=F)
p3 = read.delim("hervh_regulated_gene_TADs/hervh_3associated_genes.v2.txt",header=F)

pr = read.delim("../../data/primate_iPSC/combined-chrM.counts",skip=1)
hm = read.delim("../../data/rnaseq/rerun/combined-chrM.counts",skip=0)

cb = hm[,c(1,3,4,10)]
cb = cbind(cb, pr[match(cb$Geneid, pr$Geneid),-c(1:6)])

library(edgeR)

group = c("HS","HS",rep("MM",12),rep("CP",8))
design = model.matrix(~0+group)
counts = cb[,-c(1,2)]
rownames(counts) = cb$Geneid
y= DGEList(counts=counts,group=group)
keep = which(rowSums(cpm(y)>0.5)>=2)
y = y[keep,]
y =  calcNormFactors(y)

cpms = cpm(y)
rpkm = sweep(cpms,1,cb$Length[match(rownames(cpms),cb$Geneid)],'/')*1e3

#cpm2 = data.frame( apply(cpms[,1:2],1,mean),apply(cpms[,3:6],1,mean),apply(cpms[,7:14],1,mean))
cpm2 = data.frame( apply(rpkm[,1:2],1,mean),apply(rpkm[,3:14],1,mean),apply(rpkm[,15:22],1,mean))

colnames(cpm2) = c("Human","Marmoset","Chimp")
p5g = cpm2[which(rownames(cpm2) %in% p5$V1),]
melt1 = melt(p5g)
melt1$tad = "p5"
#g1 = ggplot(melt1) + geom_boxplot(aes(x=Var2,y=value,fill=Var2)) + 
#  scale_y_log10(breaks=c(0.1,1,10,100)) 
p3g = cpm2[which(rownames(cpm2) %in% p3$V1),]
melt2 = melt(p3g)
melt2$tad = "p3"
#g2 = ggplot(melt2) + geom_boxplot(aes(x=Var2,y=value,fill=Var2)) +
#  scale_y_log10(breaks=c(0.1,1,10,100))
melt3 = rbind(melt1,melt2)
melt3$tad = factor(melt3$tad,levels=c("p5","p3"))

g1 = ggplot(melt3) + geom_boxplot(aes(x=tad,y=value,fill=variable)) +
  annotate(geom="text",x=1,y=200,label="p=0.004")+
  xlab("") + ylab("RPKM") +
  scale_y_log10(breaks=c(0.1,1,10,100)) + 
  scale_x_discrete(labels=c("5'LTR (N=58)","3'LTR (N=51)")) +
  scale_fill_manual(values=cbbPalette[3:5]) +
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )

MM=0.1
ggplot() + geom_point(data=cpm2, aes(x=Human+MM,y=Marmoset+MM),color='gray') +
  geom_abline(intercept=0,slope=1) + 
#  stat_bin_2d(data=cpm2, aes(x=Human+MM,y=Marmoset+MM),binwidth=c(10,10)) +
  geom_point(data=p3g, aes(x=Human+MM,y=Marmoset+MM),color='blue') +
  geom_point(data=p5g, aes(x=Human+MM,y=Marmoset+MM),color='red') + 
  xlim(0,250) + ylim(0,250)
#  scale_y_sqrt() + scale_x_sqrt()

ggplot() + geom_point(data=cpm2, aes(x=Human+MM,y=Chimp+MM),color='gray') +
  geom_abline(intercept=0,slope=1) +
  geom_point(data=p5g, aes(x=Human+MM,y=Chimp+MM),color='red') +
  geom_point(data=p3g, aes(x=Human+MM,y=Chimp+MM),color='blue') +
  xlim(0,250) + ylim(0,250)

#  scale_y_log10() + scale_x_log10()



pdf("figures/regulated_genes_on_5p3p_of_HERVH.primate.pdf",height=4,width=4)
dev.off()

t.test(x=log(p5g$Human+1),y=log(p5g$Marmoset+1),paired=T)
# 0.0038
t.test(x=log(p5g$Human+1),y=log(p5g$Chimp+1),paired=T)
# 0.70
t.test(x=log(p3g$Human+1),y=log(p3g$Marmoset+1),paired=T)
# 0.155
t.test(x=log(p3g$Human+1),y=log(p3g$Chimp+1),paired=T)
# 0.88



wilcox.test(x=log(p5g$Human+1),y=log(p5g$Marmoset+1),paired=T)
# 0.03
wilcox.test(x=log(p3g$Human+1),y=log(p3g$Marmoset+1),paired=T)
# 0.07


setwd("../../analysis/di_tads.10k.2M.d0-5/dynamic_bd")

a=read.table("D00.boundary.repeats_counts.txt")
## Name D00 D02 all

D00 = length(readLines("d00.txt"))
D02 = length(readLines("d02.txt"))
STB = length(readLines("stable.txt"))


#a$V4=a$V4/10
a$P1 = a$V2/D00
a$P2 = a$V4/STB
a$FC = a$V2/D00/a$V4*STB
a$pval = 1
for (i in 1:nrow(a)){
test = matrix(c(a[i,2],D00-a[i,2],a[i,4],STB-a[i,4]),ncol=2,byrow=T)

a$pval[i] = prop.test(test,alternative="g")$p.value
}
a$fdr = p.adjust(a$pval,method="BH")
a= a[order(a$pval),]
write.table(subset(a, FC>2 & pval<0.01),"D00.enriched_repeats.txt",row.names=F,col.names=F,sep='\t',quote=F)


b = read.table("D00.boundary.repeats_counts.txt")
b$P1 = b$V3/D02
b$P2 = b$V4/STB
b$FC = b$V3/D02/b$V4*STB
b$pval = 1
for (i in 1:nrow(b)){
#test = matrix(c(b[i,2],354-b[i,2],b[i,5],2622-b[i,5]),ncol=2,byrow=T)
test = matrix(c(b[i,3],D02-b[i,3],b[i,4],STB-b[i,4]),ncol=2,byrow=T)
b$pval[i] = prop.test(test,alternative="g")$p.value
}
b$fdr = p.adjust(b$pval,method="BH")
b= b[order(b$pval),]


library(ggrepel)
pdf("repeats_enrichment_scatter.pdf",height=4,width=4)
ggplot() +
   geom_jitter(data=a,aes(x=FC,y=-log10(pval),color="ES+"),alpha=1) + 
   geom_jitter(data=b,aes(x=FC,y=-log10(pval),color="CM-"),alpha=0.5) +
   geom_label_repel(data=subset(a,FC>2 & pval<0.01), aes(x=FC,y=-log10(pval),label=V1),size=5) + 
   xlab("Fold Enrichment") + ylab("-log10 p-value") +
   coord_flip()+
   theme_bw() + 
   theme(
    legend.position="top",
    axis.text.x = element_text(face="bold"),
    axis.text.y = element_text(face="bold"),
    panel.background = element_rect(fill = NA, colour = "black"),
    panel.grid = element_blank()
    )
dev.off()


cb = merge(a[,c(1,7,8)],b[,c(1,7,8)],by="V1")

ggplot() +
  geom_point(data=cb, aes(x=-log10(pval.x),y=-log10(pval.y))) + 
  xlim(0,6)+ylim(0,6)+
  geom_label_repel(data=subset(cb,FC.x>2 & pval.x<0.01), aes(x=-log10(pval.x),y=-log10(pval.y),label=V1),size=5) 


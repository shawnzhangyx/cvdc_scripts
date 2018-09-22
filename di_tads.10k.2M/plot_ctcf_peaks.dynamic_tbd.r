setwd("../../analysis/di_tads.10k.2M/dynamic_bd")
a1= read.delim("d00.ovlp.CTCF.15k.txt",header=F)
a2= read.delim("d80.ovlp.CTCF.15k.txt",header=F)
a3= read.delim("stable.ovlp.CTCF.15k.txt",header=F)

colSums(a1[,8:13])
colSums(a2[,8:13])
colSums(a3[,8:13])

b1 = aggregate(cbind(V8,V9,V10,V11,V12,V13)~V1+V2+V3,a1,sum)
b2 = aggregate(cbind(V8,V9,V10,V11,V12,V13)~V1+V2+V3,a2,sum)
b3 = aggregate(cbind(V8,V9,V10,V11,V12,V13)~V1+V2+V3,a3,sum)

dat = rbind( colSums(b1[,4:9]>0),colSums(b2[,4:9]>0),colSums(b3[,4:9]>0))

dat2 = sweep(dat,1,c(198,329,2622),'/')

melted2 = melt(dat2)

pdf("TAD.boundary.CTCF.pdf",height=4,width=3.5)
ggplot(melted2, aes(x=Var1, y=value,fill=Var2)) +
  geom_bar(stat="identity",position="dodge",color='gray20',size=0.1) +
  scale_fill_brewer(palette="RdBu",direction=-1)+
  ylim(0,1) +
  xlab("") + ylab("Fraction") + ggtitle("TAD boundary marked by CTCF") +
  #theme_bw()  +
  theme(
    legend.text = element_text(size=5),
    axis.text.x = element_text(size=12,face="bold"),
    panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )
dev.off()


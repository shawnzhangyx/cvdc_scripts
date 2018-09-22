setwd("../../analysis/hervh/chipseq_profiles")

a=read.table("SMC3.ab9263.D00.rpkm.bw.smoothed.mat")
b=read.table("ENCODE.H1.POLR2A.rpkm.bw.smoothed.mat")
c=read.table("Input.for_cohesin.D00.rpkm.bw.smoothed.mat")

colnames(a)=colnames(b)=colnames(c) = 1:ncol(a)

LEN = 300
bg.out = apply(c[,c(1:LEN,(LEN+101):ncol(c))],1,mean)
bg.int = apply(c[,(LEN+1):(LEN+100)],1,mean)

## adjust by background. 
ad = sweep(a,1,bg.out,'-')
ad[,(LEN+1):(LEN+100)]= sweep(ad[,(LEN+1):(LEN+100)],1,(bg.out-bg.int),'+')
melted1 = melt(as.matrix(ad))
#melted1 = melt(as.matrix(a-c))
melted2 = melt(as.matrix(b-c))

#pdf(paste0(name,".smoothed.FE.mat.pdf"),width=4,height=3)
ggplot(melted1) + 
  geom_line(aes(x=Var2,y=value,color=factor(Var1),group=Var1)) +
#  geom_area(aes(x=Var2,y=value,fill=factor(Var1),group=Var1)) + 
#  geom_smooth(aes(x=Var2,y=value,color=factor(Var1),group=Var1),span=0.1,level=0) +
  theme_bw() + 
  scale_color_brewer(palette="Spectral")+
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank() )



ggplot(melted2) + geom_line(aes(x=Var2,y=value,color=factor(Var1),group=Var1)) + theme_bw() +
  scale_color_brewer(palette="Spectral")+
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank() )


#dev.off()



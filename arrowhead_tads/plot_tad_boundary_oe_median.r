setwd("../../analysis/tads/oe_median")


#files = c("D00.specific.boundary.bed.D00_HiC_Rep1.txt","D00.specific.boundary.bed.D80_HiC_Rep1.txt")

files = list.files(pattern="D00.specific.boundary")

glist=list()
glist2= list()
out = list()
for (name in files){
a=read.table(name)
a = log2(a)
a=sweep(a,1,apply(a,1,median,na.rm=T))

a[a>0.5] =0.5
a[a< -0.5] =-0.5

melted = melt(as.matrix(a))

glist[[name]] = ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile() + 
  scale_fill_gradientn(colors=c("darkblue","grey","red")) + 
#    values=c(0,0.45,0.55,1)) + 
  theme_void() + theme(legend.position="none")
#glist2[[name]] = ggplot(melted, aes(x=Var2,y=value)) + geom_boxplot()
out[[name]] = apply(a,2,median,na.rm=T)
}
out = do.call(rbind,out)
melted = melt(out)


library(gridExtra)
pdf("tad_oe_median_plot.pdf",height=5,width=5)
grid.arrange(grobs=glist,ncol=2)
ggplot(melted) + geom_line( aes(x=as.numeric(Var2),y=value,color=Var1))
dev.off()

#grid.arrange(grobs=glist2,ncol=2)


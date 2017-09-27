library(gplots)
library(gridExtra)


setwd("../../analysis/tads")
#name="D00.unique"

for (stage in c("D00","D80","gain")){
for (type in c(".within",".pre",".pos")) {
name=paste0(stage,type)
glist=list()
for ( file in list.files(path="overlap_tad_to_features",pattern=paste0(name,".*.norm_counts"),full.names=T)){
com = read.delim(file)
norm = sweep(com[,-(1:3)],1,apply(com[,-(1:3)],1,max),'/')
norm[is.na(norm)] = 0
melted = melt(as.matrix(norm))

glist[[file]] = ggplot(melted,aes(x=Var2,y=value)) + geom_boxplot()+ geom_jitter(width=0.1) +
ggtitle(sub(".*\\.(.*)\\.norm_counts.*","\\1",file) )
#heatmap.2(as.matrix(norm),Colv=FALSE,Rowv=FALSE,
#dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
#col=colorRampPalette(c("lightyellow","red")),main=sub(".*\\.(.*)\\.norm_counts.*","\\1",file)
#)
}

pdf(paste0("overlap_tad_to_features/",name,".feature_counts.pdf"),width=5,height=20)
grid.arrange(grobs=glist,ncol=1)
dev.off()
}
}

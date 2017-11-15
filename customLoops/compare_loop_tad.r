setwd("../../analysis/customLoops")

a=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
b=read.delim("loop_to_tad/loop_over_tad.pgl",header=F)
d=read.delim("loop_to_tad/loop_inter_tad.pgl",header=F)
b$name = paste(b$V1,b$V2,b$V5)
d$name = paste(d$V1,d$V2,d$V5)

a$tad = "intra"
a$tad[which(a$name %in% b$name)] = "boundary"
a$tad[which(a$name %in% d$name)] ="inter"

t = table(a$tad,a$cluster)
p = sweep(t,2,colSums(t),'/')

library(gplots)
heatmap.2(as.matrix(p),Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F)

write.table(a[,c(1,25)],"loop_to_tad/loops.tad.txt",row.names=F,sep='\t',quote=F)

setwd("../../analysis/hiccup_loops/")
##table 1: loops
loops = read.delim("replicated_loops/loops.cpb.logFC.edger.dynamic.cluster.txt")

loops$anchor1 = paste(loops$chr,loops$x1)
loops$anchor2 = paste(loops$chr,loops$y1)

tab = data.frame( rep(loops$cluster,2),c(loops$anchor1,loops$anchor2))
colnames(tab) = c("cluster","anchor")
tab$count = 1
tab2 = aggregate(count~anchor,tab,sum)
tab3 = merge(tab,tab2, by="anchor")
tab3$count.x = NULL
tab3.dup = tab3[which(tab3$count.y>1),]


single = table(tab3$cluster[which(tab3$count.y==1)])
overlap = matrix(0,nrow=6,ncol=6)
for(i in 1:nrow(tab3.dup)){
  print(i/nrow(tab3.dup))
  c1 = tab3.dup[i,"cluster"]
  match = which(tab3.dup$anchor == tab3.dup$anchor[i])
  c2.list = tab3.dup[setdiff(match,i),"cluster"]
  for (c2 in c2.list){
    if (c1 <= c2) {    overlap[c1,c2] = overlap[c1,c2] + 1 }
    else { overlap[c2,c1] = overlap[c2,c1] + 1 }
    }
    }
ratio = overlap
require(gplots)
for ( i in 1:6){
  for (j in 1:6){
    ratio[i,j] = overlap[i,j]/ num[i]/num[j]
}
}

heatmap.2(ratio,Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("lightyellow","red"))
)

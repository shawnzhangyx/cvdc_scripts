setwd("../../analysis/hiccup_loops/")

anchors = read.delim("loop_anchors.uniq.30k.num_loops.dedup.txt",header=F)
loops = read.delim("replicated_loops/loops.DegreeOfAnchors.tab")

anchors$name = paste(anchors$V1,anchors$V2+10000)
loops$a1 = paste(loops$chr1,loops$x1)
loops$a2 = paste(loops$chr1,loops$y1)

l1 = loops[,c(15,7:12)]
l2 = loops[,c(16,7:12)] 
colnames(l1)[1] = colnames(l2)[1] = "name"
loops.dup = rbind(l1,l2)
loops.dup$All = TRUE
agg = aggregate(.~name,loops.dup,FUN=sum)

agg = agg[order(-agg$All),]

mat = as.matrix(agg[,-c(1,8)])

#mat = sweep(mat,1,apply(mat,1,min),'-')

#for (i in 1:13) {
# if (length(which( agg$All == i)) > 1 ){
#hc = hclust(dist( agg[which(agg$All==i),2:7]))
#mat[which(agg$All==i),] = mat[which(agg$All==i),][hc$order,]
#} }

#mat= mat[order(km$cluster),]
rownames(mat) = 1:nrow(mat)
melted =melt(mat)

ggplot(subset(melted,value>0), aes(x=Var2, fill=factor(value))) +
  geom_bar(position="fill",stat="count")



#ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
#  scale_fill_gradient2(mid="white",high="red")
#  scale_fill_gradientn(colors=c("grey",rainbow(6)))



setwd("../../analysis/hiccup_loops/")


a = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
b = read.delim("overlap_anchors_to_features/anchors.compartments.txt",header=F)
b$name = paste(b$V1,b$V2+10000)
b$cluster_dense = a$cluster_dense[match(b$name,a$name)]
name = names(table(b$cluster_dense))[which(table(b$cluster_dense)>300)]
#ggplot(b[which(b$cluster_dense %in% name),] , aes(x=factor(cluster_dense),y=V7)) + geom_boxplot()
test = b[which(b$cluster_dense %in% name),]
test = test[order(test$cluster_dense),]
num = table(factor(test$cluster_dense))
inc = 0
for (i in 1:length(num)) { inc[i+1] = inc[i] + num[i] }

mat = as.matrix(test[,c(7:18)])

for (i in 1:length(num)) {
hc = hclust(as.dist( 1- cor(t(mat[which(test$cluster_dense==names(num)[i]),]))))
mat[which(test$cluster_dense==names(num)[i]),] = mat[which(test$cluster_dense==names(num)[i]),][hc$order,]
}

rownames(mat) = 1:nrow(mat)
melted = melt(mat)

ggplot(melted, aes(x=Var2,y=Var1, fill=value>0)) + geom_tile() + 
#  scale_fill_gradient2(high="red",low="darkblue",mid="white") + 
  geom_hline(yintercept=inc,size=1) +
  scale_y_continuous(breaks=inc[-1],labels = names(num))


test2 = test[,c(7:18,21)]
agg = aggregate(.~cluster_dense,test2, FUN=median)


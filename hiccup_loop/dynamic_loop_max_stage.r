setwd("../../analysis/hiccup_loops/")
stages = c("D00","D02","D05","D07","D15","D80")
a = read.delim("loops.cpb.logFC.edger.dynamic.txt")
counts = a[,c(2:13)]
rownames(counts) =a$name
sum = counts[,seq(1,12,2)] + counts[,seq(2,12,2)]
max =apply(sum,1,which.max)
a$max_stage = stages[max]
write.table(a,"loops.cpb.logFC.edger.dynamic.txt",row.names=F,sep='\t',quote=F)
index= t(apply(-sum,1,order))
counts.order = counts[do.call(order, as.list(as.data.frame(index))),]
norm = sweep(counts.order,1, apply(counts.order,1,function(vec){ sqrt(sum(vec**2)) }),"/")
melted = melt(as.matrix(norm))
logFC.order = a[do.call(order, as.list(as.data.frame(index))),c(18:22)]
rownames(logFC.order) = 1:nrow(logFC.order)
logFC.melt = melt(as.matrix(logFC.order))
# number of elments in each. 
max_count = table(max)
num = 0
for (i in 1:length(max_count)) num[i+1] = num[i]+max_count[i]


pdf("figures/dynamic_loops_order_by_strength.pdf")
ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() + 
  scale_fill_gradient2(high="red",mid="white") + 
  geom_hline(yintercept=num) + 
  theme(
      axis.text.y = element_blank()
      )
ggplot(logFC.melt, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  geom_hline(yintercept=num) +
  scale_fill_gradientn(colours = c("darkblue", "white", "red"),
  values = scales::rescale(c(-1, -0.3, 0, 0.3, 1)))
ggplot(a,aes(x=factor(max_stage),y=distance)) + geom_boxplot() + 
  scale_y_log10()

dev.off()
#  scale_fill_gradient2(high="red",mid="white",low="darkblue")


a = read.delim("loops.cpb.logFC.edger.nondynamic.txt")
counts = a[,c(2:13)]
rownames(counts) =a$name
sum = counts[,seq(1,12,2)] + counts[,seq(2,12,2)]
max =apply(sum,1,which.max)
a$max_stage = stages[max]
write.table(a,"loops.cpb.logFC.edger.nondynamic.txt",row.names=F,sep='\t',quote=F)
index= t(apply(-sum,1,order))
counts.order = counts[do.call(order, as.list(as.data.frame(index))),]
norm = sweep(counts.order,1, apply(counts.order,1,function(vec){ sqrt(sum(vec**2)) }),"/")
melted = melt(as.matrix(norm))
logFC.order = a[do.call(order, as.list(as.data.frame(index))),c(18:22)]
rownames(logFC.order) = 1:nrow(logFC.order)
logFC.melt = melt(as.matrix(logFC.order))
max_count = table(max)
num = 0
for (i in 1:length(max_count)) num[i+1] = num[i]+max_count[i]

pdf("figures/nondynamic_loops_order_by_strength.pdf")
ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white") +
  theme(
      axis.text.y = element_blank()
      )
ggplot(logFC.melt, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradientn(colours = c("darkblue", "white", "red"),
  values = scales::rescale(c(-1, -0.3, 0, 0.3, 1)))

ggplot(a,aes(x=factor(max_stage),y=distance)) + geom_boxplot() +
  scale_y_log10()

dev.off()


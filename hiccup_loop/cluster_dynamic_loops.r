setwd("../../analysis/hiccup_loops/edgeR")
options(scipen=99)

all= read.delim("loops_edgeR_test_allStage.txt")
cpb= read.delim("loops_cpb.txt")

files = list.files(pattern="loops_edgeR_test_D..-D...txt")
adj.list = list()
for (file in files){
  adj.list[[length(adj.list)+1]] = read.delim(file) 
}
adj.tab = do.call(cbind, adj.list)[,c(seq(7,40,8),seq(8,40,8))]
sapply(6:10,function(x){length(which(adj.tab[,x]<0.01))})
#[1] 1330  291   13   97 4859
length(which(all$fdr<0.01))
# 11725

#####################
# use the fdr for all test seems to be more reasonable than using the min
# FDR from individual tests. 
####################

#dynamic = all[which(all$fdr<0.001),]
#non_dynamic = all[-which(all$fdr<0.001),]
cpb_d = cpb[which(all$fdr<0.001),]
cpb_n = cpb[-which(all$fdr<0.001),]
# normalization factor
norm.f = sapply(1:nrow(cpb_d),function(x){ sqrt(sum( cpb_d[x,]**2))})
norm = sweep(cpb_d,1,norm.f,'/')

set.seed(1)
K = 6

km = kmeans(norm,K,100,nstart=25)
num = table(km$cluster)
num.inc = sapply(1:length(num), function(i){ sum(num[1:i])})
# order by the maximum value
norm.max = apply(norm,1,max)
norm.km = norm[order(km$cluster,-norm.max),]#-norm.f),]
melted = melt(as.matrix(norm.km))
pdf("../clusters/cpb.dynamic.norm.km.heatmap.pdf",height=20,width=10)
ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white") +
  geom_hline(yintercept=num.inc) +
  annotate("text",x=rep(12.5,K),y=num.inc-100,label=1:K) +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )
dev.off()

#norm.km$cluster = sort(km$cluster)
cpb_d.km = cpb_d[order(km$cluster,-norm.max),]
cpb_d.km$cluster = sort(km$cluster)

write.table(cpb_d.km,"../clusters/cpb.dynamic.clusters.txt",quote=F,sep='\t')
write.table(cbind(rownames(cpb_d.km),rownames(cpb_d.km),norm.km),"../clusters/cpb.dynamic.clusters.norm.treeview.cdt",quote=F,sep='\t',row.names=F)


chr = sub("(.*) (.*) (.*)", "\\1", rownames(cpb_d.km))
start = sub("(.*) (.*) (.*)", "\\2", rownames(cpb_d.km))
end = sub("(.*) (.*) (.*)", "\\3", rownames(cpb_d.km))
write.table(data.frame(chr,start,as.integer(start)+10000,cpb_d.km$cluster),"../clusters/dynamic.loop.anchor1.bed",row.names=F,col.names=F,quote=F,sep='\t')
write.table(data.frame(chr,end,as.integer(end)+10000,cpb_d.km$cluster),"../clusters/dynamic.loop.anchor2.bed",row.names=F,col.names=F,quote=F,sep='\t')

system("mkdir -p ../clusters/sep_by_cluster/")
a1= data.frame(chr,start,as.integer(start)+10000,cpb_d.km$cluster)
a2= data.frame(chr,end,as.integer(end)+10000,cpb_d.km$cluster)
colnames(a1) = colnames(a2) = c("chr","x1","x2","cluster")
anchors = rbind(a1,a2)

for (k in 1:K){
  cl = anchors[which(anchors$cluster==k),]
  cl = cl[!duplicated(cl),]
  cl$cluster = paste0("anchor",1:nrow(cl))
  write.table(cl, paste0("../clusters/sep_by_cluster/cluster.",k,".bed"),row.names=F, col.names=F,quote=F,sep='\t')
  }

non = all[which(all$fdr>=0.001),]

a1 = data.frame(non$chr, non$x1, as.integer(non$x1)+10000)
a2 = data.frame(non$chr, non$x2, as.integer(non$x2)+10000)
colnames(a1) = colnames(a2) = c("chr","x1","x2")
anchors = rbind(a1,a2)
anchors = anchors[!duplicated(anchors),]
anchors$name =  paste0("anchor",1:nrow(anchors))
write.table(anchors, "../clusters/sep_by_cluster/cluster.0.bed",row.names=F, col.names=F,quote=F,sep='\t')


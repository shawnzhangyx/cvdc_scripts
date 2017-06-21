setwd("../../analysis/hiccup_loops/edgeR")

all= read.delim("loops_edgeR_test_allStage.txt")
cpb= read.delim("loops_cpb.txt")

files = list.files(pattern="loops_edgeR_test_D..-D...txt")
adj.list = list()
for (file in files){
  adj.list[[length(adj.list)+1]] = read.delim(file) 
}
adj.tab = do.call(cbind, adj.list)[,c(seq(7,40,8),seq(8,40,8))]
cpb_d = cpb[which(all$fdr<0.001),]
cpb_n = cpb[-which(all$fdr<0.001),]

norm.f = sapply(1:nrow(cpb_d),function(x){ sqrt(sum( cpb_d[x,]**2))})
norm = sweep(cpb_d,1,norm.f,'/')

set.seed(1)

out = list()
cluster = list()
withinss = NULL

for (i in 1:15){
out[[i]] = kmeans(norm,i,100,nstart=25)
cluster[[i]] = out[[i]]$cluster
withinss = c(withinss,out[[i]]$tot.withinss)
}
totalss = out[[1]]$totss

out = data.frame(1:15,withinss/totalss)
pdf("../clusters/withinss_by_K.pdf")
plot(out[,2],main=file,ylim=c(0,1),type='o')
dev.off()




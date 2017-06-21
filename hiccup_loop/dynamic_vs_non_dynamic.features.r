setwd("../../analysis/hiccup_loops/")

all = read.delim("edgeR/loops_edgeR_test_allStage.txt")
all$name = paste(all$chr,all$x1,all$x2)
d = all[which(all$fdr<0.001),]
n = all[which(all$fdr>=0.001),]
# read the loop stage information
s = read.delim("loops_merged_across_samples.tab")
s$dynamic = ifelse(s$loopID %in% d$name, "yes","no")
## plot the histogram. 
pdf("dynamic_vs_non_dynamic/Total_number_samples_loop_called.pdf")
ggplot(s,aes(x=TotalNumSampleLoopsCalled,group=dynamic,fill=dynamic)) + 
  geom_density(alpha=0.5) +geom_vline(xintercept=12)
dev.off()

clusters = list.files(pattern="cluster...bed",path="clusters/sep_by_cluster",full.names=T)

anchor.list = list()
for (file in clusters){
data = read.delim(file,header=F)
data$cluster = sub(".*cluster.(.).bed","\\1",file)
anchor.list[[length(anchor.list)+1]] = data
}
anchors = do.call(rbind,anchor.list)

features = read.delim("overlap_features/anchor.all_features.txt")
out = merge(anchors,features, by.x=c("V1","V2","V3"),by.y=c("chr","start","end"))
out.bool = out
out.bool[,-c(1:5)] = out.bool[,-c(1:5)] >0
#ggplot(out, aes(x=CTCF,group=cluster,fill=cluster)) + geom_density(alpha=0.5)
ave = aggregate(.~cluster,data=out,mean)
ave.bool = aggregate(.~cluster,data=out.bool,mean)

ave.norm = ave[,-c(1:5)]
row.names(ave.norm) = paste0("cluster",ave$cluster)
ave.norm = sweep(ave.norm,2,as.numeric(ave.norm[1,]),'/')
require(gplots)
heatmap.2(as.matrix(ave.norm),Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("navy","white","red")),breaks=seq(from=0.5,to=1.5,by=0.01)
)

ave.bool.norm = ave[,-c(1:5)]
row.names(ave.bool.norm) = paste0("cluster",ave$cluster)
ave.bool.norm = sweep(ave.bool.norm,2,as.numeric(ave.bool.norm[1,]),'/')
require(gplots)
pdf("dynamic_vs_non_dynamic/average_features_for_each_cluster.pdf")
heatmap.2(as.matrix(apply(ave.bool.norm,2,rev)),Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
#col=colorRampPalette(c("navy","red"))
col=colorRampPalette(c("navy","white","red")),breaks=seq(from=0.5,to=1.5,by=0.01)
)
dev.off()


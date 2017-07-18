setwd("../../analysis/hiccup_loops")

a = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
colnames(a)[1:3] = c("chr","start","end")
features = read.delim("overlap_anchors_to_features/anchor.all_features.txt")
features[,-c(1:3)] = features[,-c(1:3)]>0
marks = list(a,features)
for (mark in c("H3K4me3","H3K27me3","H3K27ac","H3K4me1")){
  marks[[mark]] = read.delim(paste0("overlap_anchors_to_features/anchor.",mark,".stages.txt"))
  colnames(marks[[mark]])[4:9] = paste0(mark,'.',colnames(marks[[mark]])[4:9])
  marks[[mark]][,4:9] = marks[[mark]][,4:9]>0
  }

m = Reduce(function(...)merge(..., by=c("chr","start","end")),marks)

cluster_dense.tab = table(m$cluster_dense)
m.filter = m[which(m$cluster_dense %in% 
  names(cluster_dense.tab)[which(cluster_dense.tab>300)]),]
num = table(factor(m.filter$cluster_dense))
inc =0
for (i in 1:length(num)) inc[i+1] =inc[i]+num[i]

m.sorted = m.filter[with(m.filter, order(
  cluster_dense, H3K4me3,H3K27me3, H3K27ac, ATAC, H3K4me1, CTCF,
  H3K4me3.D00,H3K4me3.D02,H3K4me3.D05,H3K4me3.D07,H3K4me3.D15,H3K4me3.D80,
  H3K27me3.D00,H3K27me3.D02,H3K27me3.D05,H3K27me3.D07,H3K27me3.D15,H3K27me3.D80,
  H3K27ac.D00,H3K27ac.D02,H3K27ac.D05,H3K27ac.D07,H3K27ac.D15,H3K27ac.D80

  )),]

write.table(m.sorted, "anchors/anchors.sorted.by.cluster_feature.txt",row.names=F,sep='\t',quote=F)

pdf("figures/replicated_loop.anchors.cluster_feature.pdf")
mat = m.sorted[-c(1:8)]
rownames(mat) = 1:nrow(mat)
melted = melt(as.matrix(mat))
ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() + 
  scale_y_continuous(breaks=inc[-1],labels = names(num))+ 
  geom_hline(yintercept=inc,size=0.5) +
  geom_vline(xintercept=c(5,11,17,23)+2.5)+
  theme ( axis.text.x = element_text(angle=90)) 

dev.off()


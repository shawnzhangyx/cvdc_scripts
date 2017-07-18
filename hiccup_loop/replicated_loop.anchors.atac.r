setwd("../../analysis/hiccup_loops/")
##table 1: anchors.  
mark="atac"
print(mark)
anchors = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
## table 2: anchors2peak
a2peak = data.frame(fread(paste0("overlap_anchors_to_features/anchor.",mark,"_merged_peaks.txt"),header=F))
a2peak$name = paste(a2peak$V1, a2peak$V2+10000)

keep = names(table(anchors$cluster_dense))[which(table(anchors$cluster_dense)>300)]
anchors.keep = anchors[which(anchors$cluster_dense %in% keep),]
# merge loops with genes
m1 = merge(anchors.keep, a2peak, by="name")
m1 = m1[order(m1$cluster_dense),]
m1 = m1[which(m1$V4.y!="."),]
for (name in c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")){
  tmp = m1[which(m1$cluster_dense==name),c(12:15)]
  write.table(tmp,paste0("clusters/atac/",name,".bed"),row.names=F,quote=F,col.names=F,sep='\t')
  }


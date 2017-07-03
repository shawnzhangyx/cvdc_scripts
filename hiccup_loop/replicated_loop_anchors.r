
a= read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt")
feature = read.delim("overlap_anchors_to_features/anchor.all_features.txt")
feature$name = paste(feature$chr, feature$start+10000)

b = merge(a,feature,by="name")
pdf("figures/replicated_loop_anchors.overlap_feature.summary.pdf")
ggplot(subset(b,cluster_dense %in% c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")),
  aes(x=factor(cluster_dense),fill=CTCF>0)) + 
  geom_bar(position="fill",stat="count")
ggplot(subset(b,cluster_dense %in% c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")),
  aes(x=factor(cluster_dense),fill=ATAC>0)) +
  geom_bar(position="fill",stat="count")
ggplot(subset(b,cluster_dense %in% c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")),
  aes(x=factor(cluster_dense),fill=H3K4me1>0)) +
  geom_bar(position="fill",stat="count")
ggplot(subset(b,cluster_dense %in% c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")),
  aes(x=factor(cluster_dense),fill=H3K4me3>0)) +
  geom_bar(position="fill",stat="count")
ggplot(subset(b,cluster_dense %in% c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")),
  aes(x=factor(cluster_dense),fill=H3K27me3>0)) +
  geom_bar(position="fill",stat="count")
ggplot(subset(b,cluster_dense %in% c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")),
  aes(x=factor(cluster_dense),fill=H3K27ac>0)) +
  geom_bar(position="fill",stat="count")
ggplot(subset(b,cluster_dense %in% c(",,,","D00,,,",",D02,,",",,D15,",",,,D80")),
  aes(x=factor(cluster_dense),fill=TSS>0)) +
  geom_bar(position="fill",stat="count")
dev.off()



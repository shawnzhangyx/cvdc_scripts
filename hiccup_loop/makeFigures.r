setwd("../../analysis/hiccup_loops")
a=read.delim('loops/loops.cpb.logFC.edger.dynamic.cluster.txt')

a$start = as.numeric(sub(".* (.*) (.*)","\\1",a$name))
a$end = as.numeric(sub(".* (.*) (.*)","\\2",a$name))
a$dist = a$end-a$start

pdf("figures/cluster_distance_distribution.pdf")
ggplot(a, aes(x=dist,fill=factor(cluster))) + 
  geom_histogram(aes(y=..density..),bins=60,position="identity") +
  scale_x_log10(breaks=c(1e3,1e4,1e5,5e5,1e6,1e7)) + facet_wrap(~cluster,ncol=1) 
  dev.off()

setwd("../../analysis/hiccup_loops/clusters")

cpb_d = read.delim("cpb.dynamic.clusters.txt")

chr = sub("(.*) (.*) (.*)", "\\1", rownames(cpb_d))
start = sub("(.*) (.*) (.*)", "\\2", rownames(cpb_d))
end = sub("(.*) (.*) (.*)", "\\3", rownames(cpb_d))

cpb_d$distance = as.integer(end)-as.integer(start)
cpb_d$max_signal = apply(cpb_d[,c(1:12)],1,max)

pdf("dynamic_cluster.km.distance.max_signal.pdf")
ggplot(cpb_d,aes(x=factor(cluster),y=distance))+geom_boxplot() + 
  scale_y_log10(breaks=c(5e4,1e5,5e5,1e6,5e6,1e7),
    labels=c("50K","100K","500K","1M","5M","10M")) +
  coord_flip()

ggplot(cpb_d,aes(x=factor(cluster),y=max_signal))+geom_boxplot() +
 # scale_y_log10() + 
   coord_flip()
dev.off()

ggplot(cpb_d,aes(y=distance,x=1:nrow(cpb_d))) + 
stat_density_2d(aes(fill = ..level..), geom="polygon") + 
#  geom_point(position="jitter",alpha=0.5) + 
  scale_y_log10(breaks=c(5e4,1e5,5e5,1e6,5e6,1e7),
  labels=c("50K","100K","500K","1M","5M","10M")) + #geom_smooth(span=0.01)+
  coord_flip() + 





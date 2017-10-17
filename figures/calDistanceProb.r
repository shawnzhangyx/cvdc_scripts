setwd("../../analysis/distance_vs_prob")

con.list= list()
for (name in readLines("../../data/hic/meta/names.txt")){
con = read.table(paste0(name,".dist.contacts")) 
con$sample = name
con$prob = con$V2/sum(con$V2)
con.list[[name]]= con
}

combined = do.call(rbind, con.list)
colnames(combined)[1:2] = c("distance","counts")

pdf("distance_prob_log10.pdf",height=3,width=5)
# log10 vs log10
ggplot(combined, aes(x=distance,color=substr(sample,1,3),y=prob)) + geom_line() + 
#  geom_smooth()+
  scale_y_log10() + 
  scale_x_log10()  

ggplot(combined, aes(x=distance,color=substr(sample,1,3),y=prob)) + geom_line() +
  scale_y_log10(limits=c(1e-6,1)) + xlim(0,1e8)

ggplot(subset(combined,distance>5e4), aes(x=distance,color=substr(sample,1,3),y=prob)) + 
  geom_point() + geom_smooth()+
  xlim(0,2e6) #+ scale_y_log10() 

#ggplot(subset(combined,distance>5e4 & distance <6e7), 
#  aes(x=sample, y=log2(distance),fill=prob)) + 
#  stat_bin_2d()# + #scale_y_log10() +
#  scale_fill_gradient2(high="blue",low="white",limits=c(0,0.001))
dev.off()



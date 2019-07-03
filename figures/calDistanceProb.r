setwd("../../analysis/distance_vs_prob")

con.list= list()
for (name in readLines("../../data/hic/meta/names.txt")){
con = read.table(paste0(name,".dist.contacts.10k")) 
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

combined_log2 = combined
combined_log2$dist_log2 = floor(log2(combined_log2$distance+1))
combined_log2 = aggregate(prob~dist_log2+sample,combined_log2,sum)
combined_log2= combined_log2[which(combined_log2$dist_log2>0),]
combined_log2$name = substr(combined_log2$sample,1,3)
combined_log2$rep = substr(combined_log2$sample,9,12)


ave = aggregate(prob~dist_log2+name,combined_log2,mean)
se = aggregate(prob~dist_log2+name,combined_log2,sd)
out = merge(ave,se,by=c("dist_log2","name"))
colnames(out) = c("dist_log2","name","mean","se") 

breaks = seq(13,27,2)#13:27
labels = ifelse (2**breaks > 1e6, paste0(round(2**breaks/1e6,1),"M"), 
           ifelse(2**breaks> 1e3, paste0(round(2**breaks/1e3,1),"K")))

pdf("distance_prob_log2.pdf",height=4,width=6)
#ggplot(out, aes(dist_log2,color=name,y=mean)) + geom_line(size=1.2) +geom_point() + 
ggplot(combined_log2, aes(dist_log2,color=name,y=prob,group=sample,shape=rep)) + geom_line(size=1.2) +geom_point(size=2) +
  scale_color_brewer(palette="RdBu",direction=-1) +
#  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.2)+
  ylab("Fraction") +
  scale_x_continuous("distance(log2)", breaks=breaks,
  labels=labels ) +
  theme_bw() #+ theme(legend.justification = c("right", "top"),  
               #     legend.position = c(.95, .95) )
dev.off()



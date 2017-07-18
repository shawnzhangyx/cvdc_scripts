setwd("../../analysis/ab_compartments")

con.list = list()

stage = "D00"
rep = "1"

for (stage in c("D00","D02","D05","D07","D15","D80")){
  for (rep in c("1","2")){
  print(c(stage,rep))
  con = data.frame(fread(paste0("../../data/hic/matrix_raw/",stage,"_HiC_Rep",rep,"/chr1_50k.txt")))

  con$distance = con$V2-con$V1
  con2dist = aggregate(V3~distance, con, sum)
  con2dist$prob = con2dist$V3/sum(con2dist$V3)
  con2dist$sample = paste(stage,rep,sep="_")
  con.list[[length(con.list)+1]] = con2dist
}
}

combined = do.call(rbind, con.list)

pdf("../../figures/distance_prob_log10.pdf")
# log10 vs log10
ggplot(combined, aes(x=distance,color=substr(sample,1,3),y=prob)) + geom_line() + 
#  geom_smooth()+
  scale_y_log10() + 
  scale_x_log10()
ggplot(combined, aes(x=distance,color=substr(sample,1,3),y=prob)) + geom_line() +
  scale_y_log10() 

ggplot(subset(combined,distance>5e4), aes(x=distance,color=substr(sample,1,3),y=prob)) + 
  geom_point() + geom_smooth()+
  xlim(0,2e6) #+ scale_y_log10() 

ggplot(subset(combined,distance>5e4 & distance <6e7), 
  aes(x=sample, y=log2(distance),fill=prob)) + 
  stat_bin_2d()# + #scale_y_log10() +
#  scale_fill_gradient2(high="blue",low="white",limits=c(0,0.001))
dev.off()



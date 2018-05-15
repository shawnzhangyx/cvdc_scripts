a=read.delim("oe_median2/D00_HiC_Rep1.oe_median.overlap.txt",header=F)

a$dist = ceiling((a$V6-a$V3)/1e4) + 20
a$oe = ifelse(a$V8>1,1,a$V8)
ggplot(a) + #geom_boxplot(aes(x=factor(dist),y=V8)) 
  geom_tile(aes(x=dist,y=V4,fill=oe))+ 
  scale_fill_gradientn(colors=c("red","black","blue"),values=c(0,0.8,0.9,1))



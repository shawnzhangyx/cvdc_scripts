setwd("../../data/chipseq/counts/")
a = read.delim("H3K27me3.rpkm")

a$max = apply(a[,7:18],1,max)

ggplot(a, aes(x=Length,y=max)) + geom_point() + 
  scale_x_log10()

summary(a$max[which(a$Length>2000)])

a2k = a[which(a$Length>2000),]
a2k[which.min(a2k$max),]


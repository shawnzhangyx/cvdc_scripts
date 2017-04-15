library(data.table)
setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/hic/matrix/D00_HiC_Rep1/")

data=data.frame(fread("14_10000.txt"))

data$V1 = data$V1/10000
data$V2 = data$V2/10000
data$distance = data$V2-data$V1

agg = aggregate(V3~distance,mean, data=data)

ggplot(subset(data,distance<100), aes(factor(distance),V3))+ geom_boxplot()

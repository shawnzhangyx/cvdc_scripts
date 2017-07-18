setwd("../../data/hic/matrix_raw")

d0.1 = data.frame(fread("D00_HiC_Rep1/1_10000.txt"))
d15.1 = data.frame(fread("D15_HiC_Rep1/1_10000.txt"))

m = merge(d0.1,d15.1, by=c("V1","V2"))

m$distance = m$V2-m$V1
m$log.fc = log(m$V3.y/m$V3.x)

png("test.png")
ggplot(m,aes(x=distance,y=log.fc)) + geom_point() +
  scale_x_log10()

dev.off()



d0.1$name = paste(d0.1$V1, d0.1$V2)
d15.1$name = paste(d15.1$V1, d15.1$V2)



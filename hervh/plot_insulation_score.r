a=read.delim("insulation/D00_HiC_Rep1.insulation.txt",header=F)
b=read.delim("hervh.sorted_rnaseq.bed",header=F)
b$name = paste0(b$V1,":",b$V2,"-",b$V3)
a$dist = a$V6/1e4-(a$V2+a$V3)/2e4
a$dist = ceiling(a$dist)

a$V4 = factor(a$V4,levels=c(b$name))

ggplot(subset(a, V4 %in% head(b$name,50))) + geom_tile(aes(x=dist,y=V4,fill=V8))

a2=read.delim("insulation/D05_HiC_Rep1.insulation.txt",header=F)
a2$dist = a2$V6/1e4-(a2$V2+a2$V3)/2e4
a2$dist = ceiling(a2$dist)
a2$V4 = factor(a2$V4,levels=c(b$name))
ggplot(subset(a2, V4 %in% head(b$name,50))) + geom_tile(aes(x=dist,y=V4,fill=V8))


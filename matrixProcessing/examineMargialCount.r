a=read.table("../../data/hic/matrix/marginalCounts.txt",header=F)

ggplot(a,aes(x=V2,y=V1,fill=V3)) + geom_tile() + 
 scale_fill_gradient2(mid="white",high="red")

b = cast(a)
rowSums(b[,-1])
colSums(b[,-1])


setwd("../../data/chipseq/counts/")
a = read.delim("H3K27me3.counts",skip=1)
colnames(a)[7:18] = substr(colnames(a)[7:18],6,19)
#a$max = apply(a[,7:18],1,max)

ggplot(a, aes(x=Length,y=max)) + geom_point() + 
  scale_x_log10()

summary(a$max[which(a$Length>2000)])

a2k = a[which(a$Length>2000),]
a2k[which.min(a2k$max),]


b =  data.frame(fread("tiling.2k.H3K27me3.counts"))
colnames(b)[7:18] = substr(colnames(b)[7:18],6,19)
b.rpkm = b
b.rpkm[,7:18] = sweep(b[,7:18],2,colSums(b[,7:18]),'/')*1e6/2

a.rpkm = a 
a.rpkm[,7:18] = sweep(a[,7:18],2,colSums(b[,7:18]),'/')*1e6
a.rpkm[,7:18] = sweep(a.rpkm[,7:18],1,a$Length,'/')*1e3


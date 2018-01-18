a=read.delim("test/GATA4.chipseq.atac.overlap.txt",header=F)
a$rank = 1:nrow(a)
a$rank1000 = ceiling(a$rank/1000)
table(a$rank1000,a$V11>0)
plot(table(a$rank1000,a$V11>0))


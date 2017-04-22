setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/counts")

a=data.frame(fread("H3K27ac.counts",skip=1))
b = read.delim("H3K27ac.counts.summary")
sums = colSums(b[,-1])
mapped = b[1,-1] + b[4,-1]

counts = a[,-c(1:6)]

rpm = sweep(counts,2,colSums(counts),'/')*1e6
plot(rpm[,1],rpm[,2])
abline(0,1)

rpm2 = sweep(counts,2,sums,'/')*1e6
plot(rpm2[,1],rpm2[,2])
abline(0,1)

rpm3 = sweep(counts,2,as.numeric(mapped),'/')*1e6
plot(rpm3[,1],rpm3[,2])
abline(0,1)

rpm.sorted = rpm[order(-(rpm[,1]+rpm[,2])),]
rpm3.sorted = rpm3[order(-(rpm3[,1]+rpm3[,2])),]
smoothScatter(log2(rpm.sorted[,1]/rpm.sorted[,2]),pch='.',ylim=c(-4,4))
smoothScatter(log2(rpm3.sorted[,1]/rpm3.sorted[,2]),pch='.',ylim=c(-4,4))


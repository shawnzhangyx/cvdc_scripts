setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/counts")

a=data.frame(fread("H3K27me3.counts",skip=1))
b = read.delim("H3K27me3.counts.summary")
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


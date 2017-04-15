setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/counts")
a=data.frame(fread("atac.read.counts",skip=1))
b=data.frame(fread("atac.frag.counts",skip=1))

i=6
par(mfrow=c(3,4))
for(i in 7:18){
plot(a[,i],b[,i])
}



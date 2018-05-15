setwd("../../analysis/hervh")

a=read.delim("herv.rnaseq.sorted.txt",header=F,stringsAsFactors=F)
files = list.files(path="DI",pattern="DI",full.names=T)

delist = list()
for (file in files){
dat = read.delim(file,header=F)
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
#dat$name = paste0(dat$V1,":",dat$V2+400000,"-",dat$V3-400000)
pre = dat[which(dat$dist>=-2 & dat$dist<0),]
pos = dat[which(dat$dist<= 2 & dat$dist>0),]
pre.ave = aggregate(V8~V4,pre,min)
pos.ave = aggregate(V8~V4,pos,max)

comb = merge(pre.ave,pos.ave,by="V4")
comb$delta = comb$V8.y-comb$V8.x
delist[[file]] = comb[,c(1,4)]
}

out = Reduce(function(...) merge(...,by = c("V4")),
       delist)

out = out[match(a$V1,out$V4),]
out = out[!is.na(out$V4),]
colnames(out) = c("name",sub("DI\\/(.*).DI.overlap.txt","\\1",files))
write.csv(out,"herv.rnaseq_sorted.DI_delta.csv")
ggplot(out) + geom_point(aes(x=D00_HiC_Rep1,y=D00_HiC_Rep2))


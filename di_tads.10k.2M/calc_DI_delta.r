setwd("../../analysis/di_tads.10k.2M")

files = list.files(path="boundary_DI_overlaps",pattern="DI.overlap.txt",full.names=T)

delist = list()
for (file in files){
print(file)
dat = read.delim(file,header=F)
dat$dist = ceiling((dat$V6-dat$V2)/10000)-5
#dat$name = paste0(dat$V1,":",dat$V2+400000,"-",dat$V3-400000)
#num_neq0 = aggregate(V8~V4,dat,function(x){length(which(x!=0))})

pre = dat[which(dat$dist>=-4 & dat$dist<0),]
pos = dat[which(dat$dist<= 4 & dat$dist>0),]
pre.neq0 = aggregate(V8~V4,pre,function(x){length(which(x!=0))})
pos.neq0 = aggregate(V8~V4,pos,function(x){length(which(x!=0))})
pre.ave = aggregate(V8~V4,pre,mean)
pos.ave = aggregate(V8~V4,pos,mean)

#comb = do.call(merge,pre.ave,pos.ave,num_neq0,by="V4")
comb = Reduce(function(...)merge(...,by="V4"),list(pre.ave,pos.ave,pre.neq0,pos.neq0))
comb$num_neq0 = ifelse(comb[,4]>comb[,5], comb[,5],comb[,4])
comb$delta = comb$V8.y-comb$V8.x
delist[[file]] = comb[,c(1,6,7)]
}

out = Reduce(function(...) merge(...,by = c("V4")),delist)


colnames(out) = c("name",
paste0(rep(c("num_neq0","delta"),12),".",
rep(sub("boundary_DI_overlaps\\/(.*).DI.overlap.txt","\\1",files),each=2)
))

write.csv(out,"boundary_DI_overlaps/boundary.DI_delta.csv",row.names=F)
#ggplot(out) + geom_point(aes(x=D00_HiC_Rep1,y=D00_HiC_Rep2))


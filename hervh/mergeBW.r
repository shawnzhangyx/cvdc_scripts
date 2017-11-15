files = list.files(path="rnaseq",pattern="rnaseq_D...out",full.names=T)

dat = list()

for (file in files){
dat[[file]] = read.table(file)[,c(1,5)]
}

dat2 = Reduce(function(...) merge(...,by = c("V1")),dat)
colnames(dat2) = c("name","D00","D02","D05","D07","D15","D80")

dat2 = dat2[order(-dat2$D00),]
#dat2 = dat2[order(-apply(dat2[,-1],1,sum)),]
dat2$name = factor(dat2$name, levels=dat2$name)
melted = melt(dat2) 

ggplot(melted, aes(x=variable,y=name,fill=log2(value))) + geom_tile() + 
  scale_fill_gradient2(high='red',low='blue')


chr = sub("(.*):(.*)-(.*)","\\1",dat2$name)
start = sub("(.*):(.*)-(.*)","\\2",dat2$name)
end = sub("(.*):(.*)-(.*)","\\3",dat2$name)


write.table(data.frame(chr,start,end),"hervh.sorted_rnaseq.bed",row.names=F,col.names=F,
  quote=F,sep='\t')


dat3 = dat2[which(dat2$D00>=1),]
chr = sub("(.*):(.*)-(.*)","\\1",dat3$name)
start = sub("(.*):(.*)-(.*)","\\2",dat3$name)
end = sub("(.*):(.*)-(.*)","\\3",dat3$name)
write.table(data.frame(chr,start,end),"hervh.bw_gt1.bed",row.names=F,col.names=F,
  quote=F,sep='\t')




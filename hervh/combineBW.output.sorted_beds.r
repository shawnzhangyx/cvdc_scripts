setwd("../../analysis/hervh")
files = list.files(path="rnaseq",pattern="^rnaseq_D...out",full.names=T)

dat = list()

for (file in files){
dat[[file]] = read.table(file)[,c(1,8)]
}

dat2 = Reduce(function(...) merge(...,by = c("V1")),dat)
colnames(dat2) = c("name","D00","D02","D05","D07","D15","D80")

dat2 = dat2[order(-dat2$D00),]
#dat2 = dat2[order(-apply(dat2[,-1],1,sum)),]
dat2$name = factor(dat2$name, levels=dat2$name)
melted = melt(dat2) 

pdf("figures/HERV.exp.sorted.pdf")
ggplot(melted, aes(x=variable,y=name,fill=log2(value))) + geom_tile() + 
  scale_fill_gradient2(high='red',low='blue') +
  theme( axis.text.y=element_blank() )
  dev.off()



chr = sub("(.*):(.*)-(.*)","\\1",dat2$name)
start = sub("(.*):(.*)-(.*)","\\2",dat2$name)
end = sub("(.*):(.*)-(.*)","\\3",dat2$name)

write.table(dat2,"herv.rnaseq.sorted.txt",row.names=F,col.names=F,quote=F,sep='\t')
write.table(data.frame(chr,start,end),"hervh.sorted_rnaseq.bed",row.names=F,col.names=F,
  quote=F,sep='\t')
write.table(data.frame(chr,start,end,paste0("HERVH",1:length(chr))),"hervh.sorted_rnaseq.name.bed",row.names=F,col.names=F, quote=F,sep='\t')




#dat3 = dat2[which(dat2$D00>=1),]
#chr = sub("(.*):(.*)-(.*)","\\1",dat3$name)
#start = sub("(.*):(.*)-(.*)","\\2",dat3$name)
#end = sub("(.*):(.*)-(.*)","\\3",dat3$name)
#write.table(data.frame(chr,start,end),"hervh.bw_gt1.bed",row.names=F,col.names=F,
#  quote=F,sep='\t')

a=read.table("hervh.sorted_rnaseq.bed")
a$name = paste0(a$V1,":",a$V2,"-",a$V3)
b=read.table("hervh.merged.strand.bed")
b= b[match(a$name,b$V4),]

write.table(b,"hervh.sorted_rnaseq.strand.bed",row.names=F,col.names=F,quote=F,sep='\t')




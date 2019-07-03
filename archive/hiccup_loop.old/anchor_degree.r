setwd("../../analysis/hiccup_loops/")

anchors = read.delim("loop_anchors.uniq.30k.num_loops.txt",header=F)
sorted = anchors[order(anchors$V1,anchors$V2),]

pre = sorted$V2[1]
sorted$pos = sorted$V2
for (i in 2:nrow(sorted)){
if ( abs(sorted$V2[i]-pre)>=20000) {
  pre = sorted$V2[i]
}
sorted$pos[i] = pre
}
rmdup = sorted[!duplicated(sorted[,c(1,5)]),]
rmdup = rmdup[order(-rmdup$V4),]

tab = table(rmdup$V4)
dat = data.frame(tab)
## 
write.table(rmdup[,1:4],"loop_anchors.uniq.30k.num_loops.dedup.txt",row.names=F,col.names=F,sep='\t',quote=F)

pdf("anchors/anchor.num_loops.barplot.pdf")
ggplot(dat) +  geom_col(aes(x=Var1,y=Freq))
dev.off()


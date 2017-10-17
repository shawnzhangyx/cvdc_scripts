setwd("../../analysis/tads/")

a=read.delim("combined_tads.uniq.final.txt")

num = colSums(a[,16:21])
dat = data.frame(names=names(num),num)

pdf("figures/TAD_number.pdf",width=3,height=3)
ggplot(dat,aes(x=names,y=num)) +geom_bar(stat="identity",fill=cbbPalette[6],width=0.75) +
  geom_line(aes(x=1:6,y=num),col='red',size=1) + geom_point(aes(x=1:6,y=num),size=1) +
  theme_bw()
dev.off()

a$dist = a$x2-a$x1

names=colnames(a)[16:21]

dist= list()
for (i in 1:6){
  tmp = data.frame( dist = a$dist[which(a[,i+15]==1)],names=names[i])
  dist[[i]] = tmp
  }
dist=do.call(rbind,dist)

pdf("figures/TAD_size.pdf",width=3,height=3)
ggplot(dist, aes(x=names,y=dist/1000))+geom_boxplot(outlier.shape = NA) +ylim(0,0.75e3)+
  ylab("TAD size(Kb)") + theme_bw()
dev.off()



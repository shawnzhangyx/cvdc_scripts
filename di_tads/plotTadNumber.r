setwd("../../analysis/di_tads/tad_di/")
#system("wc -l *.bed > tad.num.txt")
a=read.table("tad.num.txt")
a=a[1:12,]
a$names= substr(a$V2,1,3)
a$rep = substr(a$V2,5,8)

agg1 = aggregate(V1~names,a,mean)
agg2 = aggregate(V1~names,a,min)
agg3 = aggregate(V1~names,a,max)
agg = merge(agg1,agg2,by="names")
agg = merge(agg,agg3,by="names")
colnames(agg) = c("Stage","mean","min","max")

pdf("../figures/DI_tad_number_changes.pdf",width=4,height=3)
#ggplot(a, aes(x=names,y=V1)) + geom_point() + 
#  stat_summary(fun.y=mean, geom="line", aes(group=1)) +
#  ylab("Number of TADs")+ xlab("Stage") + ylim(0,5000)
#ggplot(agg, aes(x=Stage,y=mean)) +
ggplot(a, aes(x=names,y=V1,group=rep)) +
#  geom_errorbar(aes(ymin=min, ymax=max), width=.3) +
    geom_line(aes(group=rep),color='grey') +
    geom_point(aes(shape=rep)) + ylim(3000,5000) + theme_bw()
dev.off()



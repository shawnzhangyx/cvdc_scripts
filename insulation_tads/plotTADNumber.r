setwd("../../analysis/insulation_tads/insulation_tads/")
#system("wc -l *.bed > tad.num.txt")
a=read.table("tad.num.txt")
a=a[1:12,]
a$names= substr(a$V2,1,3)

agg1 = aggregate(V1~names,a,mean)
agg2 = aggregate(V1~names,a,min)
agg3 = aggregate(V1~names,a,max)
agg = merge(agg1,agg2,by="names")
agg = merge(agg,agg3,by="names")
colnames(agg) = c("Stage","mean","min","max")

pdf("../Insulation_tad_number_changes.pdf",width=3,height=3)
ggplot(agg, aes(x=Stage)) +
    geom_line(aes(group=1,y=mean,color='TAD Number')) +
    geom_errorbar(aes(ymin=min, ymax=max,color='TAD Number'), width=.3) +
    geom_point(aes(y=mean, color='TAD Number')) +
    theme_bw() +
    theme(legend.position="top",axis.text.x = element_text(angle=90,size=12,face="bold",vjust=0.5))

dev.off()


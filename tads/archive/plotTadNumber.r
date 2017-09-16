setwd("../../analysis/tads/tad_calls/")
system("wc -l *.bed > tad.num.txt")
a=read.table("tad.num.txt")
a=a[1:12,]
a$names= substr(a$V2,1,3)

pdf("tad_number_changes.pdf")
ggplot(a, aes(x=names,y=V1)) + geom_point() + 
  stat_summary(fun.y=mean, geom="line", aes(group=1)) +
  ylab("Number of TADs")+ xlab("Stage") + ylim(0,5000)
dev.off()



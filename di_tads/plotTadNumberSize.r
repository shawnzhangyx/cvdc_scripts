setwd("../../analysis/di_tads/tad_di/")
## TAD number
a=read.table("tad.num.txt")
a=a[1:12,]
a$names= substr(a$V2,1,3)

agg1 = aggregate(V1~names,a,mean)
agg2 = aggregate(V1~names,a,min)
agg3 = aggregate(V1~names,a,max)
agg = merge(agg1,agg2,by="names")
agg = merge(agg,agg3,by="names")
colnames(agg) = c("Stage","mean","min","max")

ggplot(agg, aes(x=Stage,y=mean)) +
    geom_errorbar(aes(ymin=min, ymax=max), width=.3) +
    geom_line(aes(group=1),color='grey') +
    geom_point() + ylim(3000,5000) + theme_bw()
dev.off()
## TAD size 
files = list.files(pattern="TAD.bed")
p.list = list()
for (file in files){
data = data.frame(fread(file))
data$width = data$V3-data$V2
data$name = sub("(D.._Rep.).TAD.bed","\\1",file)
#median = median(data$width,na.rm=T)/1000
p.list[[length(p.list)+1]] = data
}

comb = do.call(rbind,p.list)
comb$Stage = sub("(D..)_Rep.","\\1",comb$name)

source("~/gists/summarySE.r")
tgc <- summarySE(comb, measurevar="width", groupvars=c("Stage"),na.rm=T)

dat = cbind(agg, tgc[,c(3,5)])

pdf("../figures/DI_tad_number_size.pdf",width=3,height=3.5)

  ggplot(dat, aes(x=Stage)) + 
    geom_line(aes(group=1,y=mean,color='TAD Number')) +
    geom_errorbar(aes(ymin=min, ymax=max,color='TAD Number'), width=.3) +
    geom_point(aes(y=mean, color='TAD Number')) + 
    geom_line(aes(group=2,y=width/100-3000,color="TAD Size")) +
    geom_errorbar(aes(ymin=(width-se)/100-3000, ymax=(width+se)/100-3000,color="TAD Size"), width=.2) +
    geom_point(aes(y=width/100-3000, color='TAD Size')) +
#    scale_y_continuous(name="TAD Number") + 
    scale_y_continuous(sec.axis = sec_axis(~.*100+300000,breaks=c(65E4,70E4,75E4),labels=c("650","700","750"),name = "TAD Size [KB]")) + 
    theme_bw() +
    theme(legend.position="top",axis.text.x = element_text(angle=90,size=12,face="bold",vjust=0.5)) 

dev.off()


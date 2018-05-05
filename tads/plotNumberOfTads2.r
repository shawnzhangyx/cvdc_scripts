setwd("../../analysis/tads/arrowhead_tads/")
system("wc -l *.10000_blocks > tad.num.txt")

a=read.table("tad.num.txt")
a=a[1:12,]
a$names= substr(a$V2,1,3)
agg1 = aggregate(V1~names,a,mean)
agg2 = aggregate(V1~names,a,min)
agg3 = aggregate(V1~names,a,max)
agg = merge(agg1,agg2,by="names")
agg = merge(agg,agg3,by="names")
colnames(agg) = c("Stage","mean","min","max")


pdf("arrowhead_TAD_number.pdf",width=3,height=3)
ggplot(agg, aes(x=Stage)) +
    geom_line(aes(group=1,y=mean,color='TAD Number')) +
    geom_errorbar(aes(ymin=min, ymax=max,color='TAD Number'), width=.3) +
    geom_point(aes(y=mean, color='TAD Number')) +
    theme_bw() +
    theme(legend.position="top",axis.text.x = element_text(angle=90,size=12,face="bold",vjust=0.5))
dev.off()

files = list.files(pattern="10000_blocks")
p.list = list()
for (file in files){
data = data.frame(fread(file))
data$width = data$x2-data$x1
data$name = sub("(D..\\.Rep.).10000_blocks","\\1",file)
#median = median(data$width,na.rm=T)/1000
p.list[[length(p.list)+1]] = data
}

comb = do.call(rbind,p.list)
comb$Stage = sub("(D..)\\.Rep.","\\1",comb$name)

source("~/gists/summarySE.r")
tgc <- summarySE(comb, measurevar="width", groupvars=c("Stage"),na.rm=T)

dat = cbind(agg, tgc[,c(3,5)])

pdf("arrowhead_TAD_size.pdf",width=3,height=3)
ggplot(dat, aes(x=Stage)) +
  geom_line(aes(group=2,y=width/1000,color='TAD Size')) + 
  geom_errorbar(aes(ymin=(width-se)/1000, ymax=(width+se)/1000,color='TAD Size'), width=.2)+
  geom_point(aes(y=width/1000,color='TAD Size')) +
  theme_bw() +
  theme(legend.position="top",axis.text.x = element_text(angle=90,size=12,face="bold",vjust=0.5))

dev.off()



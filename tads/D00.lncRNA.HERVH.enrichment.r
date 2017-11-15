setwd("../../analysis/tads/")

set=c("D00","Control","D00","Control")
type=c("lncRNA","lncRNA","HERVH","HERVH")
total=354
num =c(73,51.7,84,42.2)

test1 = matrix(c(73,354-73,51.7,354-51.7),ncol=2,byrow=T)
test2 = matrix(c(84,354-84,42.2,354-42.2),ncol=2,byrow=T)

p1 = prop.test(test1)
p2 = prop.test(test2)

dat = data.frame(set,type,num/total)
dat$set=factor(dat$set,c("D00","Control"))

pdf("lncRNA_HERV_enrichment.pdf",height=3,width=3)
 ggplot() +
  geom_bar(data = dat,aes(x=type,fill=set,y=num.total),stat="identity",position="dodge") +
  ylab("Fraction") + xlab("") +
  geom_path(data=data.frame(x=c(0.75,0.75,1.25,1.25),y=c(0.25,0.26,0.26,0.25)),aes(x,y)) +
  annotate("text",x=1,y=0.27,label=format(p2$p.value,scientific=T,digits=2)) +
  geom_path(data=data.frame(x=c(1.75,1.75,2.25,2.25),y=c(0.22,0.23,0.23,0.22)),aes(x,y)) +
  annotate("text",x=2,y=0.24,label=format(p1$p.value,digits=3)) +
  theme_bw()
dev.off()



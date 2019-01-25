library(gridExtra)

setwd("../../analysis/hervh_ki")
args = commandArgs(trailing=T)
start = args[1]
end = args[2]
fwt = args[3]
fki = args[4]
fwt2 = args[5]

start = 17500000
end = 18100000
fwt = "HERV-KO.chr20.5k.mat"
fki = "HERV-KI2.chr20.5k.mat"
fwt2 = "HERV-KI1.chr20.5k.mat"

wt = data.frame(fread(paste0("matrix_norm/",fwt)))
ki = data.frame(fread(paste0("matrix_norm/",fki)))


wt = wt[which( wt$V1 > start & wt$V1 < end & wt$V2 > start & wt$V2 < end),]
ki = ki[which( ki$V1 > start & ki$V1 < end & ki$V2 > start & ki$V2 < end),]

wt$norm = wt$V3/sum(wt$V3)*50000
ki$norm = ki$V3/sum(ki$V3)*50000

df = merge(wt,ki,by=c("V1","V2"))
df$fc = log2(df$norm.y/df$norm.x)
df$diff = df$norm.y-df$norm.x

LIMIT = 10
g1 = ggplot() + geom_tile(data=wt,aes(x=V1,y=V2,fill=ifelse(norm>LIMIT,LIMIT,norm) ))+
  geom_tile(data=wt,aes(x=V2,y=V1,fill=ifelse(norm>LIMIT,LIMIT,norm) )) +
  scale_fill_gradientn(colors=c("white","red","red"),values=c(0,0.75,0.85,1))

#  scale_fill_gradient(high="red",low="white")

g2 = ggplot() + geom_tile(data=ki,aes(x=V1,y=V2,fill=ifelse(norm>LIMIT,LIMIT,norm) ))+ 
  geom_tile(data=ki,aes(x=V2,y=V1,fill=ifelse(norm>LIMIT,LIMIT,norm) )) +
  scale_fill_gradientn(colors=c("white","red","red"),values=c(0,0.75,0.85,1))

pdf("HERV-KI6.5kb.obs.pdf",height=10,width=8)
grid.arrange(g1,g2)
dev.off()

ggplot() + geom_tile(data=df,aes(x=V1,y=V2,
  fill=ifelse(fc>1,1,ifelse(fc< -1,-1,fc)) ))+
  scale_fill_gradient2(high="red",mid="white",low="blue")

ggplot() + geom_tile(data=df,aes(x=V1,y=V2,fill=ifelse(diff>20,20, ifelse(diff< -20,-10,diff)) ))+
    scale_fill_gradient2(high="red",mid="white",low="blue")


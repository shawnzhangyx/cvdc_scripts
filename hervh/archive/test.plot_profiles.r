setwd("../../analysis/hervh/chipseq_profiles")
a=read.delim("SMC3.ab9263.D00.FE.bw.mat",skip=1,header=F)
a=read.delim("RAD21_ab992.D00.FE.bw.mat",skip=1,header=F)

b=read.delim("../hervh.sorted_rnaseq.bed",header=F)
b$name = paste0(b$V1,":",b$V2,"-",b$V3)
b$rank = 1:nrow(b)
b$tier = ceiling(b$rank/50)

a$tier = b$tier[match(a$V4,b$name)]

tl = list()
for (tier in 1:8){
  tmp = a[which(a$tier==tier),-c(1:6,507)]
  r = apply(tmp,2,mean,na.rm=T)
  tl[[tier]] = r
}
tl = do.call(rbind,tl)
melted = melt(tl)

BIN=8

tl2 = list()
for (i in 1:ncol(tl)) {
le = ifelse(i-BIN<0,0,i-BIN)
ri = ifelse(i+BIN<ncol(tl),i+BIN,ncol(tl))
tl2[[i]] = apply(tl[,le:ri],1,mean)
}
 
tl2 = do.call(cbind, tl2)

melted2 = melt(tl2)
#ggplot(melted2) + geom_line(aes(x=Var2,y=value,color=factor(Var1),group=Var1))


pdf("SMC3.ab9263.D00.bw.FE.pdf",width=4,height=3)
ggplot(subset(melted2,Var1==1)) + geom_line(aes(x=Var2,y=value,color=factor(Var1),group=Var1)) + theme_bw() + 
  theme(
  legend.position="none",
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank() )
ggplot(melted2) + geom_line(aes(x=Var2,y=value,color=factor(Var1),group=Var1)) + theme_bw() +
  scale_color_brewer(palette="Spectral")+ 
  theme(
#  legend.position="none",
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank() )

dev.off()


pdf("RAD21.D00.bw.FE.pdf",width=4,height=3)
ggplot(subset(melted2,Var1==1)) + geom_line(aes(x=Var2,y=value,color=factor(Var1),group=Var1)) + theme_bw() +
  theme(
  legend.position="none",
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank() )
dev.off()



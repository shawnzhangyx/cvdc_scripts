setwd("../../analysis/hervh/chipseq_profiles")

name=commandArgs(trailing=T)[1]

a=read.delim(paste0(name,".mat.gz"),skip=1,header=F)

b=read.delim("../hervh.sorted_rnaseq.bed",header=F)
b$name = paste0(b$V1,":",b$V2,"-",b$V3)
b$rank = 1:nrow(b)
b$tier = ceiling(b$rank/50)

a$tier = b$tier[match(a$V4,b$name)]

tl = list()
for (tier in 1:8){
  tmp = a[which(a$tier==tier),-c(1:6,ncol(a))]
  r = apply(tmp,2,mean,na.rm=T)
  tl[[tier]] = r
}
tl = do.call(rbind,tl)
melted = melt(tl)

BIN=10

tl2 = list()
for (i in 1:ncol(tl)) {
le = ifelse(i-BIN<0,0,i-BIN)
ri = ifelse(i+BIN<ncol(tl),i+BIN,ncol(tl))
tl2[[i]] = apply(tl[,le:ri],1,mean)
}
 
tl2 = do.call(cbind, tl2)
write.table(tl2,paste0(name,".smoothed.mat"),row.names=F,col.names=F,quote=F,sep='\t')


melted2 = melt(tl2)

pdf(paste0(name,".smoothed.mat.pdf"),width=4,height=3)
ggplot(melted2) + geom_line(aes(x=Var2,y=value,color=factor(Var1),group=Var1)) + theme_bw() +
  scale_color_brewer(palette="Spectral")+ 
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank() )

dev.off()

setwd("../../analysis/tads")
a=read.delim("combined_tads.sigDiff.txt")


a = a[order(a$D00,a$D02,a$D05,a$D07,a$D15,a$D80),]
stages = a[,16:21]
rownames(stages) =1:nrow(stages)
melted = melt(as.matrix(stages))
insu = a[,4:15]
rownames(insu) =1:nrow(insu)
melted2 = melt(as.matrix(insu))

pdf("figures/TAD_sigDiff.pdf")
ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile() 
ggplot(melted2,aes(x=Var2,y=Var1,fill=value)) + geom_tile()+
#  scale_fill_gradientn(high="red",low="white")
  scale_fill_gradientn(colors=c("white","red","red"), values=c(0,0.5,1,1,2))

dev.off()


D00 = a[which(a$D00==TRUE & rowSums(stages)==1),]
write.table(D00[,1:3],"stage_specific_tads/D00.within.tads",row.names=F,col.names=F,sep='\t',quote=F)
D00.pre = D00[,1:3]
D00.pre$dist = D00.pre$x2-D00.pre$x1
D00.pre$x2=D00.pre$x1
D00.pre$x1=D00.pre$x1-D00.pre$dist
write.table(D00.pre[,1:3],"stage_specific_tads/D00.pre.tads",row.names=F,col.names=F,sep='\t',quote=F)

D00.pos = D00[,1:3]
D00.pos$dist = D00.pos$x2-D00.pos$x1
D00.pos$x1=D00.pos$x2
D00.pos$x2=D00.pos$x2+D00.pos$dist
write.table(D00.pos[,1:3],"stage_specific_tads/D00.pos.tads",row.names=F,col.names=F,sep='\t',quote=F)

D80 = a[which(a$D80==FALSE & rowSums(stages)==5),]
write.table(D80[,1:3],"stage_specific_tads/D80.within.tads",row.names=F,col.names=F,sep='\t',quote=F)
D80.pre = D80[,1:3]
D80.pre$dist = D80.pre$x2-D80.pre$x1
D80.pre$x2=D80.pre$x1
D80.pre$x1=D80.pre$x1-D80.pre$dist
write.table(D80.pre[,1:3],"stage_specific_tads/D80.pre.tads",row.names=F,col.names=F,sep='\t',quote=F)

D80.pos = D80[,1:3]
D80.pos$dist = D80.pos$x2-D80.pos$x1
D80.pos$x1=D80.pos$x2
D80.pos$x2=D80.pos$x2+D80.pos$dist
write.table(D80.pos[,1:3],"stage_specific_tads/D80.pos.tads",row.names=F,col.names=F,sep='\t',quote=F)

gain = a[which(a$D00==FALSE & rowSums(stages)>0),]
write.table(gain[,1:3],"stage_specific_tads/gain.within.tads",row.names=F,col.names=F,sep='\t',quote=F)
gain.pre = gain[,1:3]
gain.pre$dist = gain.pre$x2-gain.pre$x1
gain.pre$x2=gain.pre$x1
gain.pre$x1=gain.pre$x1-gain.pre$dist
write.table(gain.pre[,1:3],"stage_specific_tads/gain.pre.tads",row.names=F,col.names=F,sep='\t',quote=F)

gain.pos = gain[,1:3]
gain.pos$dist = gain.pos$x2-gain.pos$x1
gain.pos$x1=gain.pos$x2
gain.pos$x2=gain.pos$x2+gain.pos$dist
write.table(gain.pos[,1:3],"stage_specific_tads/gain.pos.tads",row.names=F,col.names=F,sep='\t',quote=F)





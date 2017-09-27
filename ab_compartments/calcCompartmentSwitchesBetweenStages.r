setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/ab_compartments/")
data = read.delim("pc1_data/combined.matrix",header=F)

mat = data[,-(1:3)]
rownames(mat) = paste(data$V1,data$V2,data$V3)
mat = ifelse(mat>0,1,-1)
mat = (mat[,seq(1,12,2)] +mat[,seq(2,12,2)])/2
replicated = apply(mat,1,prod)

mat.rep = mat[which(replicated!=0),]
colnames(mat.rep) = c("D00","D02","D05","D07","D15","D80")
mat.rep = as.data.frame(mat.rep)
#mat.rep = mat.rep[order(rowSums(mat.rep),mat.rep$D00,mat.rep$D02,mat.rep$D05,mat.rep$D07,mat.rep$D15, mat.rep$D80),]
mat.rep = mat.rep[order(mat.rep$D00,mat.rep$D02,mat.rep$D05,mat.rep$D07,mat.rep$D15, mat.rep$D80),]
mat.rep.m = melt(as.matrix(mat.rep))

## write each stage switch
for ( idx in 2:6){
  BtoA= rownames(mat.rep)[which(mat.rep[,idx]-mat.rep[,idx-1] == 2)]
  AtoB= rownames(mat.rep)[which(mat.rep[,idx]-mat.rep[,idx-1] == -2)]
  write.table(gsub(" ","\t",BtoA),paste0("compartmentSwitch/",colnames(mat.rep)[idx],".BtoA.bed"),row.names=F,col.names=F,quote=F)
  write.table(gsub(" ","\t",AtoB),paste0("compartmentSwitch/",colnames(mat.rep)[idx],".AtoB.bed"),row.names=F,col.names=F,quote=F)
}


switch = sapply(2:ncol(mat.rep)-1, function(x){ table (mat.rep[,x+1]-mat.rep[,x]) })
rownames(switch) = c("AtoB","NoChange","BtoA")
colnames(switch) = c("D0-D2","D2-D5","D5-D7","D7-D15","D15-D80")
switch = sweep(switch,2,colSums(switch),'/')
switch.c = switch[-2,]*100
melted = melt(switch.c,id.var=rownames(switch.c))

dat.rep = data[match(rownames(mat.rep),paste(data$V1,data$V2,data$V3)),]
dat.rep2 = (dat.rep[,seq(4,15,2)]+dat.rep[,seq(5,15,2)])/2
rownames(dat.rep2) = 1:nrow(dat.rep2)
dat.rep.m = melt(as.matrix(dat.rep2))



pdf("compartmentSwitches.pdf")
ggplot(melted,aes(x=Var2,y=value,fill=Var1)) + 
  geom_bar(stat="identity",position=position_dodge()) +
  scale_fill_manual(values=cbbPalette[c(3,7)])+
  ylab("%Compartment Change") + xlab("BetweenStages")


ggplot(mat.rep.m, aes(x=Var2,y=Var1,fill=value)) + geom_tile() + 
  scale_fill_gradient2(high=cbbPalette[7],low=cbbPalette[3])+ 
  theme( axis.text.y= element_blank(),
  axis.ticks = element_blank())

ggplot(dat.rep.m, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high=cbbPalette[7],low=cbbPalette[3])+
  theme( axis.text.y= element_blank(),
  axis.ticks = element_blank())
dev.off()

1-length(which(abs(rowSums(mat.rep))==6))/nrow(mat.rep)
# 0.184


#p = ggplot(melted,aes(x=Var2,y=Var1,fill=value)) + geom_tile()+ 
#    scale_fill_gradient2(mid="white",high='red')

write.table(switch.c,"compartmentSwitch/switchRatioBetweenStage.txt",sep='\t',quote=F)


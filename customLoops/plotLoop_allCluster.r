setwd("../../analysis/customLoops")
loop = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt",stringsAsFactors=F)
a1p = read.delim("loops/loops.dynamic.cluster.anchor1.txt",stringsAsFactors=F)
a2p = read.delim("loops/loops.dynamic.cluster.anchor2.txt",stringsAsFactors=F)
a1 =a1p
a2=a2p

## move promoter to a1. 
a2pi = which( ( a2$H3K4me3>0 ) #| rowSums(a2[,28:33])>0 )
              & ( a1$H3K4me3==0 )) #& rowSums(a1[,28:33])==0)) 
tmp = a2[a2pi,]
a2[a2pi,] = a1[a2pi,]
a1[a2pi,] = tmp

### sort by an defined order. 
lout = list()
files = list.files(path="clusters",pattern="[1-5].order.bed",full.names=T)
for (file in files){
  lout[[file]] = read.table(file)}
beds = do.call(rbind,lout)
beds$name = paste(beds$V1,beds$V2,beds$V3)
od = match(beds$name,loop$name)
a1 = a1[od,]
a2 = a2[od,]

#mat1[,1:6] = sweep(mat1[,1:6],1,apply(mat1[,1:6],1,max),'/')
lp = loop[,seq(2,13,2)] + loop[,seq(3,13,2)]
lp = sweep(lp,1,apply(lp,1,max),'/')[od,]

mat1 = a1[,4:39]
for (i in seq(1,31,6)){
mat1[,i:(i+5)] = sweep(mat1[,i:(i+5)],1,apply(mat1[,i:(i+5)],1,max),'/')
}
#mat1[,31:34] = sweep(mat1[,31:34],1,apply(mat1[,31:34],1,max),'/')
mat1[is.na(mat1)] = 0
mat2 = a2[,4:39]
for (i in seq(1,31,6)){
mat2[,i:(i+5)] = sweep(mat2[,i:(i+5)],1,apply(mat2[,i:(i+5)],1,max),'/')
}
#mat2[,31:34] = sweep(mat2[,31:34],1,apply(mat2[,31:34],1,max),'/')
mat2[is.na(mat2)] = 0

colnames(lp) = sub("(D..)_.","HiC_\\1",colnames(lp))
colnames(mat1) = paste0("A1.",colnames(mat1))
colnames(mat2) = paste0("A2.",colnames(mat2))
comb = cbind(lp,mat1,mat2)
rownames(comb) = nrow(comb):1

type = rep("Other",nrow(comb))
type[ rowSums(comb[,grepl("A1.H3K4me1",colnames(comb))])>0 & rowSums(comb[,grepl("A2.H3K4me1",colnames(comb))])>0 ] = "E-E"
type[ rowSums(comb[,grepl("A1.H3K4me3",colnames(comb))])>0 & rowSums(comb[,grepl("A2.H3K4me1",colnames(comb))])>0 ] = "P-E"
type[ rowSums(comb[,grepl("A1.H3K4me3",colnames(comb))])>0 & rowSums(comb[,grepl("A2.H3K4me3",colnames(comb))])>0 ] = "P-P"
type.df = data.frame(type)
#ggplot(type.df) + geom_point(aes(x=1:nrow(type.df),type))

melted = melt(as.matrix(comb))

pdf(paste0("figures/cluster1-5.heatmap.pdf"),height=7,width=12)
ggplot(melted,aes(x=Var2,y=Var1,fill=value))+ geom_tile() + 
  scale_fill_gradientn(colors=#c("#fff5f0","#fcbba1","#a50f15"), 
  c("white","pink","red"),
    values=c(0,0.7,1)) +
  geom_vline(xintercept=c(seq(6,72,6)+0.5)) +  
  annotate("text",x=c(seq(0,72,6))+0.6,y=nrow(comb)*1.02,
label=c("HiC",rep(c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","RNAseq","CTCF"),2)),
    hjust = 0)+
  xlab("Marks") + ylab("Loops")+
  theme_minimal() + 
  theme( 
    panel.background = element_rect(fill = NA, colour = "black"),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    legend.justification="top")

ggplot(type.df) + geom_tile(aes(x=1,y=nrow(type.df):1,fill=type)) + 
  scale_fill_manual(values =cbbPalette[c(4,9,5,6)]) + 
    theme(
      panel.background = element_rect(fill = NA, colour = "black"),
      panel.grid = element_blank(),
    )

dev.off()


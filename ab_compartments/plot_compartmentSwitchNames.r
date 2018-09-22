setwd("../../analyais/ab_compartments")
a=read.delim('compartmentSwitch/switchType.bed',header=F)

dat = data.frame(table(a$V5))
dat$dynamic = ifelse(dat$Var1 %in% c("A","B"),"N","Y")
dat$Var1 = factor(dat$Var1, levels=rev(c("A","B","AB","BA","ABA","BAB")))
pdf("compartmentSwitchType_Fraction.pdf",width=2,height=4)
ggplot(dat) + 
  geom_bar(aes(x=1,y=Freq,fill=Var1),stat="identity",position="fill") + 
  xlab("") + ylab("Fraction")  + 
  theme_bw() + 
  theme(panel.border = element_blank(),
    axis.ticks.x=element_blank(),
    axis.text.x=element_blank(),
    axis.line = element_line(),
    legend.position="left"
  )
dev.off()


#b=read.delim("compartmentSwitch/anyStage.switch.bed",header=F)
b=data.frame(fread("pc1_data/combined.matrix"))
dyn = a[which(a$V4>0),]
b2 = b[which( paste(b$V1,b$V2) %in% paste(dyn$V1,dyn$V2)),]

mat = b2[,-c(1:3)]
cor = cor(t(mat))
hc = hclust(as.dist(1-cor),method="average")
mat.o = mat[hc$order,]
rownames(mat.o) = 1:nrow(mat.o)
melted = melt(as.matrix(mat.o))
cor2 = cor(mat)
hc2 = hclust(as.dist(1-cor2),method="average")
hc2$order = 1:12

pdf("dyn_switch_plots.pdf")
plot(as.dendrogram(hc),horiz=T, leaflab = "none")
plot(hc2)

ggplot(melted) + geom_tile(aes(x=Var2,y=Var1,fill=value)) +
#  scale_fill_gradientn(colors=c("#2c7fb8","white","#de2d26"),name='corner\nscore') +
  scale_fill_gradient2(low="#2c7fb8",high="#de2d26") +
  theme_void() +
  theme( legend.position="bottom")
  dev.off()


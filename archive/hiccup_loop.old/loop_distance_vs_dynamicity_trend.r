setwd("../../analysis/hiccup_loops")

d = read.delim("loops.cpb.logFC.edger.dynamic.txt")
n = read.delim("loops.cpb.logFC.edger.nondynamic.txt")

com = rbind(d,n)
com = com[,c("distance","dynamic","max_stage")]

com$dis_bin = NULL
com$dis_bin[which(com$distance< 100e3)] = "<100K"
com$dis_bin[which(com$distance>= 100e3 & com$distance <500e3)] = "100-500K"
com$dis_bin[which(com$distance>= 500e3 & com$distance <5e6)] = "500K-5M"
#com$dis_bin[which(com$distance>= 2e6 & com$distance <5e6)] = "2-5M"
com$dis_bin[which(com$distance>= 5e6)] = ">5M"
com$Class = paste(ifelse(com$dynamic,"Dyn","Non"),com$max_stage)
com$dis_bin = factor(com$dis_bin,levels=c("<100K","100-500K","500K-5M",">5M"))

pdf("figures/loops.distance_vs_dynamicity.pdf")
ggplot(com, aes(x=dis_bin, fill=dynamic)) + 
  geom_bar(position="fill",stat="count") + 
  annotate(geom="text",x=(1:4),y=rep(1.05,4),label=table(com$dis_bin))

cp = rep(cbbPalette[1:6],2)
for (i in 7:12) cp[i] = alpha(cp[i],0.3)

ggplot(com, aes(x=dis_bin,color=dynamic,fill=Class)) +
  geom_bar(position="fill",stat="count") +
  scale_fill_manual(values=cp) + 
  scale_color_manual(values=c(NA,"black"))+ 
  annotate(geom="text",x=(1:4),y=rep(1.05,4),label=table(com$dis_bin))

dev.off()

com = rbind(d,n)
test = com[,c(29,30,2:13)]
test$max = apply(test[,c(3:14)],1,max)
test.sorted = test[order(test$distance,test$max),]

mat = as.matrix(sweep(test.sorted[,3:14],1,apply(test.sorted[,c(3:14)],1,max),'/'))
rownames(mat) = 1:nrow(mat)

melted = melt(mat)

ggplot() + geom_raster(data=melted,aes(x=Var2, y=Var1, fill=value),interpolate = FALSE) + 
  scale_fill_gradient2(high="red",low="white") +
  scale_x_continuous(limits=c(0,nrow(test.sorted)),breaks=c(0,5000,10000,15000)) +
#  labels=test.sorted$distance[c(1,5000,10000,15000)]) +
  theme( axis.text.x = element_text(angle = 90, hjust = 1))
#  geom_rug(aes(y=(1:nrow(test.sorted))[which(test.sorted$dynamic==TRUE)]),size=0.1)




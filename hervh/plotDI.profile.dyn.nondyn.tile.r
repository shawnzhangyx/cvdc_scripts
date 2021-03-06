setwd("../../analysis/hervh")

a=read.delim("hervh.dynamicBoundaries.txt",header=F)
b=read.delim("hervh.nonDynamicBoundaries.txt",header=F)

files = list.files(path="DI",pattern="DI",full.names=T)

#for (file in files[seq(1,12,2)]){
t50 = read.delim("hervh.sorted_rnaseq.bed",header=F)[1:50,]
t50$name = paste0(t50$V1,":",t50$V2,"-",t50$V3)
idx = 1
dat = read.delim(files[idx],header=F)
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
dat2 = dat[which(dat$V4 %in% t50$name ),]
#dat2 = dat[which(dat$V4 %in% t50$name & !( dat$V4 %in% a$V1) ),]
DIST=8

dat2 = dat2[which(abs(dat2$dist)< DIST),]
dat2.median = aggregate(V8~V4,dat2,median)
dat2$V8 = dat2$V8-dat2.median$V8[match(dat2$V4,dat2.median$V4)]
dat2$V8[abs(dat2$V8) > 100] = 100* sign(dat2$V8)[abs(dat2$V8) > 100]

pdf("figures/HERVH.top50TAD.DI.tile.pdf",width=4,height=2)
ggplot(subset(dat2,dist!=100)) +
    geom_tile(aes(x=dist,y=V4,fill=V8)) +
    scale_fill_gradient2(low=cbbPalette[6],high=cbbPalette[7]) +
    theme_bw() +ggtitle(files[idx])
dev.off()



dyn.list = list()
pdf("figures/HERVH.dynamicTAD.DI.tile.pdf",width=4,height=2)
for (idx in seq(1,12,2)){

#print(file)
dat = read.delim(files[idx],header=F)
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
dyn1 = dat[which(dat$V4 %in% a$V1),]
dyn1$V4 = factor(dyn1$V4, levels=a$V1)
non1 = dat[which(dat$V4 %in% b$V1),]
non1$V4 = factor(non1$V4, levels=b$V1)


dat = read.delim(files[idx+1],header=F)
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
dyn2 = dat[which(dat$V4 %in% a$V1),]
dyn2$V4 = factor(dyn2$V4, levels=a$V1)
non2 = dat[which(dat$V4 %in% b$V1),]
non2$V4 = factor(non2$V4, levels=b$V1)

dyn = merge(dyn1[,c(4,8,10)],dyn2[,c(4,8,10)],by=c("V4","dist"))
dyn$V8 = apply(dyn[,c(3,4)],1,mean)
non = merge(non1[,c(4,8,10)],non2[,c(4,8,10)],by=c("V4","dist"))
non$V8 = apply(non[,c(3,4)],1,mean)

DIST=8
dyn2 = dyn[which(abs(dyn$dist) <DIST),]
dyn2.median = aggregate(V8~V4,dyn2,median)
dyn2$V8 = dyn2$V8-dyn2.median$V8[match(dyn2$V4,dyn2.median$V4)]
dyn2$V8[abs(dyn2$V8) > 100] = 100* sign(dyn2$V8)[abs(dyn2$V8) > 100]

dyn2.agg = aggregate(V8~dist,dyn2,median)
dyn2.agg$sample = files[idx]
dyn.list[[files[idx]]] = dyn2.agg

print(
ggplot(subset(dyn2,dist!=100)) +
    geom_tile(aes(x=dist,y=V4,fill=V8)) +
    scale_fill_gradient2(low=cbbPalette[6],high=cbbPalette[7]) + 
    theme_bw() +ggtitle(files[idx]) 
)
}
dev.off()

#ggplot(subset(non2,dist!=100)) +
#    geom_tile(aes(x=dist,y=V4,fill=V8)) +
#    scale_fill_gradient2(low=cbbPalette[6],high=cbbPalette[7]) +
#    theme_bw() +ggtitle(files[1])

dyn.tab = do.call(rbind,dyn.list)

pdf("figures/HERVH.dynamicTAD.ave_DI.D0-D80.pdf",width=4,height=4)
ggplot(subset(dyn.tab,abs(dist)<8)) + geom_bar(aes(x=dist,y=V8,fill=V8>0),stat="identity") + 
  ylim(-40,40) + 
  facet_grid(sample~.) + 
  scale_fill_manual(values=cbbPalette[c(6,7)]) + 
#  scale_color_manual(values=cbbPalette[c(6,7)]) +
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )
  
  dev.off()




setwd("../../analysis/hervh/")
a=read.delim("hervh.dynamicBoundaries.txt",header=F)
files = list.files(path="PC1_overlap",pattern="PC1",full.names=T)

dyn.list = list()

for (idx in 1:length(files)){

dat = read.delim(files[idx],header=F)
dat$dist = ceiling((dat$V6-dat$V2)/50000)-8
dyn = dat[which(dat$V4 %in% a$V1),]
dyn$sample = files[idx]
#dyn.agg = aggregate(V8~dist,dyn,median)
#dyn.agg$sample = files[idx]
dyn.list[[files[idx]]] = dyn
}
dyn.tab = do.call(rbind,dyn.list)

#pdf("figures/HERVH.dynamicTAD.Dixon.pdf",width=4,height=4)

ggplot(subset(dyn.tab,abs(dist)<8)) + geom_tile(aes(x=dist,y=V4,fill=V8)) +
#  ylim(-20,20) 
  facet_grid(sample~.) +
  scale_fill_gradient2(high="red",low="darkblue") +
#  scale_color_manual(values=cbbPalette[c(6,7)]) +
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )

#  dev.off()


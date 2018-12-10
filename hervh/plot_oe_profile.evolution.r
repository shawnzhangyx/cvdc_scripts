setwd("../../analysis/hervh/")
out.list = list()
for (file in c("oe_profile/D00_HiC_Rep1.csv","evolution_analysis/chimp/chimp_oe.csv","evolution_analysis/marmoset/marmoset_oe.csv","evolution_analysis/mouse/mouse_oe.csv"
 )){
a = read.csv(file)
a$sample=file
out.list[[file]] = a
}

out = do.call(rbind,out.list)
med = aggregate(V3~sample+center,out,median,na.rm=T)

out = merge(out,med,by=c("sample","center"))
out$norm = out$V3.x/out$V3.y

out$x = ceiling((out$V1-out$center)/1e4)
out$y = ceiling((out$V2-out$center)/1e4)

agg = aggregate(cbind(V3.x,norm)~x+y+sample,out,median,na.rm=T)

pdf("figures/oe_profile.evolution.pdf",height=10,width=5)

ggplot(agg) + geom_tile(aes(x=x,y=y,fill=log2(V3.x))) +
  scale_fill_gradientn(colors=c("#000099","#FFFFFF","#CC0033"),values=c(0,0.6,1)) +
#  scale_fill_gradient2(low="#000099",high="#CC0033")+
  facet_grid(sample~.) + 
 theme(
 panel.background = element_rect(fill = NA, colour = "black"),
 panel.grid = element_blank()
 )
 dev.off()
#out2 = out
#out2$norm[out2$norm>2] = 2
#out2$norm[out2$norm<0.5] = 0.5

#ggplot(out2) + geom_jitter(aes(x=x,y=y,color=log2(norm)),size=.25) +
# scale_color_gradientn(colors=c("darkblue","white","red"),values=c(0,0.5,1)) +
#  facet_grid(sample~.)



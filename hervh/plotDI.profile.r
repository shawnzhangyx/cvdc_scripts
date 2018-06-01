setwd("../../analysis/hervh")

a=read.delim("herv.rnaseq.sorted.txt",header=F,stringsAsFactors=F)
a$rank = 1:nrow(a)
a$tier = ceiling(a$rank/50)
exp = aggregate(V2~tier,a,median)


files = list.files(path="DI",pattern="DI",full.names=T)

#delist = list()
pdf("figures/DI.overlap.herv.exp.brackets.pdf",width=4,height=10)
for (file in files[seq(1,12,2)]){
print(file)
dat = read.delim(file,header=F)
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
dat$rank = a$rank[match(dat$V4,a$V1)]
dat$tier = ceiling(dat$rank/50)


agg = aggregate(V8~tier+dist,dat[,c(12,10,8)],median)

#pdf(paste0("figures/",sub("DI\\/(.*).DI.overlap.txt","\\1",file),".DI.herv_brackets.pdf"))
print(ggplot(subset(agg, abs(dist)<10 & tier<7) ) +
  geom_bar(aes(x=dist,y=V8,fill=V8>0),stat="identity") + 
  ylim(-40,40) +
  facet_grid(factor(tier)~.) +
  scale_fill_manual(values=cbbPalette[c(6,7)]) +
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  ) )
#dev.off()
}
dev.off()
write.table(exp,"hervh.tier.vs.medianBW.txt",row.names=F,quote=F,sep='\t')


pdf("figures/DI.tile.overlap.herv.exp.brackets.pdf",width=4,height=10)
for (file in files[seq(1,12,2)]){
print(file)
dat = read.delim(file,header=F)
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
dat$rank = a$rank[match(dat$V4,a$V1)]
dat$tier = ceiling(dat$rank/50)
dat$V4 = factor(dat$V4, levels=unique(dat$V4))

print(
  ggplot(subset(dat,abs(dist)<20 & tier <2) ) +
  geom_tile(aes(x=dist,y=V4,fill=V8)) + 
  scale_fill_gradient2(low=cbbPalette[6],high=cbbPalette[7])

  geom_bar(aes(x=dist,y=V8,fill=V8>0),stat="identity") +
  facet_grid(factor(tier)~.) +
  scale_fill_manual(values=cbbPalette[c(6,7)]) +
  theme_bw())
#dev.off()
}
dev.off()


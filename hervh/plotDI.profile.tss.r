setwd("../../analysis/hervh")

a=read.delim("rnaseq/all_gene.rnaseq_D00.out",header=F,stringsAsFactors=F)
a=a[order(-a$V8),]
a$rank = rank(-a$V8)

b2=read.delim("herv.rnaseq.sorted.txt",header=F)
rang = quantile(b2$V2[1:50],c(0.4,0.6))

b= read.delim("TSSs.dist.CTCF_peaks.txt",header=F)

matched = a[which(a$V8> rang[1] & a$V8<rang[2]),]
matched$CTCF = matched$V1 %in% b$V4[which(b$V17<=2e4)]

files = list.files(path="tss_DI_profile",pattern="DI",full.names=T)
file = files[1]
dat = read.delim(file,header=F)
dat$V4 = factor(dat$V4, levels=unique(dat$V4))
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40

dat2 = dat[which(dat$V4 %in% matched$V1),]
dat2$CTCF = dat2$V4 %in% b$V4[which(b$V17<=2e4)]

agg = aggregate(V8~CTCF+dist,dat2[,c(11,10,8)],median)

  ggplot(subset(agg,abs(dist)<=10) ) +
  geom_bar(aes(x=dist,y=V8,fill=V8>0),stat="identity") +
  ylim(-20,20) +
  facet_grid(factor(CTCF)~.) +
  scale_fill_manual(values=cbbPalette[c(6,7)]) +
  theme_bw()



#delist = list()
type = read.delim("../../data/rnaseq/gene.rpkm.type.txt")


pdf("figures/DI.overlap.herv.exp.brackets.pdf",width=4,height=10)
for (file in files[seq(1,12,2)]){
print(file)
dat = read.delim(file,header=F)
dat$V4 = factor(dat$V4, levels=unique(dat$V4))
dat$dist = ceiling((dat$V6-dat$V2)/10000)-40
dat$rank = a$rank[match(dat$V4,a$V1)]
dat$rank = as.numeric(dat$V4)
dat$tier = ceiling(dat$rank/100)

agg = aggregate(V8~tier+dist,dat[,c(12,10,8)],median)

#pdf(paste0("figures/",sub("DI\\/(.*).DI.overlap.txt","\\1",file),".DI.herv_brackets.pdf"))
  print(
  ggplot(subset(agg, abs(dist)<10 & tier %in% seq(1,152,10) )  ) +
  geom_bar(aes(x=dist,y=V8,fill=V8>0),stat="identity") + 
  ylim(-20,20) + 
  facet_grid(factor(tier)~.) +
  scale_fill_manual(values=cbbPalette[c(6,7)]) +
  theme_bw()
  )
#dev.off()
}
dev.off()


  ggplot(subset(dat,abs(dist)<20 & tier==6) ) +
  geom_tile(aes(x=dist,y=V4,fill=V8)) +
  scale_fill_gradient2(low=cbbPalette[6],high=cbbPalette[7])

  geom_bar(aes(x=dist,y=V8,fill=V8>0),stat="identity") +
  facet_grid(factor(tier)~.) +
  scale_fill_manual(values=cbbPalette[c(6,7)]) +
  theme_bw()


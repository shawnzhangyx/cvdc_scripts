setwd("../../analysis/hervh")

files = list.files(path="chipseq_bwOverBed",pattern="*.out",full.names=T)
names = sub(".*\\/(.*)\\.out","\\1",files)
names = sub("ENCODE.","",names)
a = read.table("hervh.sorted_rnaseq.strand.bed")
fc.list=NULL

for (file in files) {
  tmp = read.table(file)[,c(1,5)]
  tmp = tmp[match(a$V4,tmp$V1),]
  fc = median(tmp$V5[1:50])/median(tmp$V5[51:300])
  fc.list = c(fc.list,fc)
  }

dat = data.frame(names,fc.list)
dat = dat[order(-dat$fc.list),]
dat$names = factor(dat$names,levels=dat$names)

library(ggrepel)
pdf("figures/HERVH.chip.enrichment.high.vs.low.pdf",height=4,width=10)
ggplot(dat) + 
  geom_bar(aes(x=names,y=fc.list),stat='identity',fill='gray') +
  geom_hline(yintercept=1,linetype="dashed",color='red') + 
  ylab("ChIPseq.Fold.Enrichment") + xlab("") + 
  theme(
  axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
    legend.position="none",
    panel.background = element_rect(fill = NA, colour = "black"),
    panel.grid = element_blank()
  )
dev.off()
pdf("figures/HERVH.chip.enrichment.high.vs.low.points.pdf",height=4,width=4)
  ggplot(dat) +
  geom_point(aes(x=names,y=fc.list)) +
  geom_label_repel(data=subset(dat,names %in% c("POLR2AphosphoS5","POLR2A","H3K4me2",
  "H3K4me3","H3K27ac","Jian.RAD21","JUND","CHD7","SP1","NANOG","RIC.SMC3",
  "RIC.SMC1","CTCF")),aes(x=names,y=fc.list,label=names)) +
  geom_hline(yintercept=1,linetype="dashed",color='red') +
  ylab("ChIPseq.Fold.Enrichment") + xlab("") +
  theme(
  axis.text.x = element_blank(),
    legend.position="none",
    panel.background = element_rect(fill = NA, colour = "black"),
    panel.grid = element_blank()
  )

dev.off()

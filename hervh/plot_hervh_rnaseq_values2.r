setwd("../../analysis/hervh/")
a=read.delim("rnaseq/hervh.merged.rnaseq.counts",skip=1)
b=read.delim('../../data/rnaseq/rerun/combined-chrM.counts',skip=1)
colnames(a) = colnames(b)

a2=rbind(a,b)

rpm = sweep(a2[,7:18],2,colSums(a2[,7:18]),'/')*1e6
rpkm = sweep(rpm,1,a2$Length,'/')*1e3
rpkm2 = (rpkm[,1:6]+rpkm[,7:12])/2
rpkm3 = cbind(a2$Geneid,rpkm2)
colnames(rpkm3) = c("Geneid","D00","D02","D05","D07","D15","D80")
rpkm3 = rpkm3[order(-rpkm3$D00),]

hervh = rpkm3[grep("chr",rpkm3$Geneid),]
hervh$rank = 1:nrow(hervh)

qtl = quantile(rpkm3$D00,c(0.99,0.95,0.90,0.75))
names(qtl) = c("1%","5%","10%","25%")

pdf("figures/rnaseq.sorted_by_rpkm.D00.v2.pdf",height=4,width=3)

ggplot(subset(hervh,rank<200)) + 
  #geom_bar(aes(x=rank,y=V2),stat="identity") + 
  geom_point(aes(x=rank,y=D05),color=cbbPalette[8]) +
  geom_point(aes(x=rank,y=D02),color='#68A9CF') +
  geom_point(aes(x=rank,y=D00),color='#2267AD') +  
  xlab("Rank") + ylab("RPKM") + xlim(0,200)+
  scale_y_sqrt(breaks=c(0,10,100,250),
    sec.axis=sec_axis(~.,breaks=qtl,name="Top% in hESC"))+
#  scale_y_sqrt(breaks=c(0,10,100,500,1000,2000)) + 
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )
  dev.off()

#  theme_bw() 

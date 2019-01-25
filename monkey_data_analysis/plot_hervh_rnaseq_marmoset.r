setwd("../../analysis/monkey_hervh/")
a=read.delim("rnaseq/calJac3.hervh.rnaseq.counts",skip=1,stringsAsFactors=F)
b=read.delim('../../data/rnaseq_pipe/calJac3/combined-chrM.counts',skip=1,stringsAsFactors=F)
colnames(a) = colnames(b)

a2=rbind(a,b)

rpm = sweep(a2[,-c(1:6)],2,colSums(a2[,-c(1:6)]),'/')*1e6
rpkm = sweep(rpm,1,a2$Length,'/')*1e3
rpkm2 = (rpkm[,1]+rpkm[,2])/2
rpkm3 = data.frame(a2$Geneid,rpkm2)
colnames(rpkm3) = c("Geneid","Exp")
rpkm3 = rpkm3[order(-rpkm3$Exp),]

hervh = rpkm3[grep("chr",rpkm3$Geneid),]
# remove hervh sequence less than 2000 in length.
hervh = hervh[which( (a$End-a$Start)>2000),]

hervh$rank = 1:nrow(hervh)

qtl = quantile(rpkm3$Exp,c(0.99,0.95,0.90,0.75))
names(qtl) = c("1%","5%","10%","25%")

pdf("calJac3.rnaseq.sorted_by_rpkm.pdf",height=4,width=3)

ggplot(subset(hervh,rank<200)) + 
  geom_point(aes(x=rank,y=Exp),color='#2267AD') +  
  xlab("Rank") + ylab("RPKM") + xlim(0,200) +
  scale_y_sqrt(breaks=c(0,10,100,250),limits=c(0,250),
    sec.axis=sec_axis(~.,breaks=qtl,name="Top%"))+
  theme(
  panel.background = element_rect(fill = NA, colour = "black"),
  panel.grid = element_blank()
  )
  dev.off()

#  theme_bw() 

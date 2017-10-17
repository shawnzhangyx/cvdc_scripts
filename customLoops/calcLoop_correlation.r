setwd("../../analysis/customLoops")
loop = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt",stringsAsFactors=F)
a1p = read.delim("loops/loops.dynamic.cluster.anchor1.txt",stringsAsFactors=F)
a2p = read.delim("loops/loops.dynamic.cluster.anchor2.txt",stringsAsFactors=F)
a1 =a1p
a2=a2p

## move promoter to a1. 
a2pi = which( ( a2$H3K4me3>0 | rowSums(a2[,28:33])>0 )
              & ( a1$H3K4me3==0 & rowSums(a1[,28:33])==0)) 
tmp = a2[a2pi,]
a2[a2pi,] = a1[a2pi,]
a1[a2pi,] = tmp

lp = loop[,seq(2,13,2)] + loop[,seq(3,13,2)]

#cor.h3k27ac = sapply(1:nrow(lp), function(x){ 
#    cor.test(as.numeric(a1[x,16:21]),as.numeric(a2[x,16:21]))$estimate })
#cor.h3k4me1 = sapply(1:nrow(lp), function(x){
#    cor.test(as.numeric(a1[x,22:27]),as.numeric(a2[x,22:27]))$estimate })
cor.h3k27ac.loop = sapply(1:nrow(lp), function(x){
    cor.test(as.numeric(a1[x,16:21])+as.numeric(a2[x,16:21]),as.numeric(lp[x,]))$estimate })
cor.h3k4me1.loop = sapply(1:nrow(lp), function(x){
    cor.test(as.numeric(a1[x,22:27])+as.numeric(a2[x,22:27]),as.numeric(lp[x,]))$estimate })
cor.h3k27me3.loop = sapply(1:nrow(lp), function(x){
    cor.test(as.numeric(a1[x,10:15])+as.numeric(a2[x,10:15]),as.numeric(lp[x,]))$estimate })
cor.h3k4me1.rnaseq = sapply(1:nrow(lp), function(x){
    cor.test(as.numeric(a2[x,22:27]),as.numeric(a1[x,28:33]))$estimate })
cor.h3k27ac.rnaseq = sapply(1:nrow(lp), function(x){
    cor.test(as.numeric(a2[x,16:21]),as.numeric(a1[x,28:33]))$estimate })
cor.h3k27me3.rnaseq = sapply(1:nrow(lp), function(x){
    cor.test(as.numeric(a2[x,10:15]),as.numeric(a1[x,28:33]))$estimate })


dat = rbind( #data.frame(correlation=cor.h3k27ac[!is.na(cor.h3k27ac)],type="anchor.H3K27ac"),
            # data.frame(correlation=cor.h3k4me1[!is.na(cor.h3k4me1)],type="anchor.H3K4me1"),
             data.frame(correlation=cor.h3k27ac.loop[!is.na(cor.h3k27ac.loop)],type="H3K27ac.Loop"),
             data.frame(correlation=cor.h3k4me1.loop[!is.na(cor.h3k4me1.loop)],type="H3K4me1.Loop"),
             data.frame(correlation=cor.h3k27me3.loop[!is.na(cor.h3k27me3.loop)],type="H3K27me3.Loop"),
             data.frame(correlation=cor.h3k27ac.rnaseq[!is.na(cor.h3k27ac.rnaseq)],type="H3K27ac.Transcription"),
             data.frame(correlation=cor.h3k4me1.rnaseq[!is.na(cor.h3k4me1.rnaseq)],type="H3K4me1.Transcription"),
             data.frame(correlation=cor.h3k27me3.rnaseq[!is.na(cor.h3k27me3.rnaseq)],type="H3K27me3.Transcription")
             )


pdf(paste0("figures/anchor.mark.correlation.pdf"),height=4,width=3)
#ggplot(dat,aes(x=factor(type),y=correlation,fill=sub("(.*)\\.(.*)","\\1",type))) + geom_boxplot() +
#  ylab("Pearson correlation") + 
#  scale_fill_brewer(palette="Blues") +
#  theme ( axis.text.x = element_text(angle=45,hjust=1),legend.position="none") 

ggplot(subset(dat,sub("(.*)\\.(.*)","\\2",type)=="Transcription"),
  aes(x=factor(type),y=correlation,fill=sub("(.*)\\.(.*)","\\1",type))) + geom_boxplot() +
  ylab("Pearson correlation") +
  scale_fill_brewer(palette="Blues") +
  theme ( axis.text.x = element_text(angle=45,hjust=1),legend.position="none")

dev.off()





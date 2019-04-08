setwd("../../analysis/hervh/")
library(tidyverse)

a=read_delim("D00.rna_seq.ranked_by_rpkm.v2.bed",delim="\t",col_names=F)

a2 = a[which(a$X7>0),]
a2$tier = floor(1:nrow(a2)/1000)

c = read_delim("all_genes.TSSs.dist.CTCF_peaks.txt",delim="\t",col_names=F)
a2$ctcf_distance = c$X16[match(a2$X4,c$X4)]
a2$ctcf_peak = a2$ctcf_distance < 2e4 
  
## TSS plot

b = read_delim("tss_DI_profile/all_gene.TSS.DI.overlap.D00_HiC_Rep1.txt",delim="\t",col_names=F)

b$dist = ceiling((b$X6-b$X3)/10000)+40


b2 = b[which(b$X4 %in% a2$X4),]
b2$tier = a2$tier[match(b2$X4,a2$X4)]
b2$ctcf_peak = a2$ctcf_peak[match(b2$X4,a2$X4)]

b3 =  aggregate(X8~dist+tier+ctcf_peak,b2,median)
b3p = b3 
b3p$X8[b3p$X8>20] = 20

hervh = a2[grep("chr",a2$X4)[1:50],]

herv.di = b[which(b$X4 %in% hervh$X4),]
herv.di.agg =  aggregate(X8~dist,herv.di,median)
herv.di.agg$tier = -1
herv.di.agg$ctcf_peak = FALSE
b4 = rbind(b3p, herv.di.agg)

rpkm.agg = aggregate(X7~tier,a2,median)


pdf("figures/gene_TSS_DI_profile.rank_by_exp.pdf")
ggplot(subset(b4,abs(dist)<=20)) + geom_tile(aes(x=dist,y=tier,fill=X8)) +
    scale_fill_gradient2(high="red",low="darkblue") + facet_wrap(~ctcf_peak)

ggplot(hervh) +geom_bar(aes(tier)) + coord_flip()

ggplot(a2) +geom_bar(aes(x=tier,fill=ctcf_peak),stat="count",position="fill") + coord_flip()

ggplot(rpkm.agg) + geom_col(aes(x=tier,y=X7))+ 
    xlab("Tier") + ylab("RPKM") +
    coord_flip() 

dev.off()

#ggplot(subset(herv.di.agg,abs(dist)<=20)) + geom_tile(aes(x=dist,y=1,fill=X8)) +
#  scale_fill_gradient2(high="red",low="darkblue") 


#b4 =  aggregate(X8~dist+tier,b2,median)

#ggplot(b4) + geom_tile(aes(x=dist,y=tier,fill=X8)) +
#  scale_fill_gradient2(high="red",low="darkblue") .



### for TES


a=read_delim("D00.rna_seq.ranked_by_rpkm.v2.bed",delim="\t",col_names=F)

a2 = a[which(a$X7>0),]
a2$tier = floor(1:nrow(a2)/1000)

c = read_delim("all_genes.TESs.dist.CTCF_peaks.txt",delim="\t",col_names=F)
a2$ctcf_distance = c$X16[match(a2$X4,c$X4)]
a2$ctcf_peak = a2$ctcf_distance < 2e4 

## TSS plot

b = read_delim("tss_DI_profile/all_gene.TES.DI.overlap.D00_HiC_Rep1.txt",delim="\t",col_names=F)

b$dist = ceiling((b$X6-b$X3)/10000)+40


b2 = b[which(b$X4 %in% a2$X4),]
b2$tier = a2$tier[match(b2$X4,a2$X4)]
b2$ctcf_peak = a2$ctcf_peak[match(b2$X4,a2$X4)]

b3 =  aggregate(X8~dist+tier+ctcf_peak,b2,median)
b3p = b3 
b3p$X8[b3p$X8>20] = 20

hervh = a2[grep("chr",a2$X4)[1:50],]

herv.di = b[which(b$X4 %in% hervh$X4),]
herv.di.agg =  aggregate(X8~dist,herv.di,median)
herv.di.agg$tier = -1
herv.di.agg$ctcf_peak = FALSE
b4 = rbind(b3p, herv.di.agg)

rpkm.agg = aggregate(X7~tier,a2,median)


pdf("figures/gene_TES_DI_profile.rank_by_exp.pdf")
ggplot(subset(b4,abs(dist)<=20)) + geom_tile(aes(x=dist,y=tier,fill=X8)) +
  scale_fill_gradient2(high="red",low="darkblue") + facet_wrap(~ctcf_peak)

ggplot(hervh) +geom_bar(aes(tier)) + coord_flip()

ggplot(a2) +geom_bar(aes(x=tier,fill=ctcf_peak),stat="count",position="fill") + coord_flip()

ggplot(rpkm.agg) + geom_col(aes(x=tier,y=X7))+ 
  xlab("Tier") + ylab("RPKM") +
  coord_flip() 

dev.off()


setwd("../../analysis/atacCenteredSites/counts")

a=data.frame(fread("ATAC.norm"))
b=data.frame(fread("H3K27ac.norm"))

cor = sapply(1:nrow(a), function(i){ 
      cor.test(as.numeric(a[i,7:12]),as.numeric(b[i,7:12]))$estimate } )

pval = sapply(1:nrow(a), function(i){
      cor.test(as.numeric(a[i,7:12]),as.numeric(b[i,7:12]))$p.value } )

qval = p.adjust(pval,method="BH")


dat = cbind(a[,1:4],cor,pval,qval)


ggplot(dat) +  geom_histogram(aes(cor) )

ggplot(subset(dat,qval<0.05)) +  geom_histogram(aes(cor) )

dat2 = subset(dat,qval<0.05)



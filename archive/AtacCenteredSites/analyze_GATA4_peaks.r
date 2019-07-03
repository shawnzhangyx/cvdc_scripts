setwd("../../analysis/atacCenteredSites")

a=data.frame(fread("counts/ATAC.norm"))
b=data.frame(fread("counts/H3K27ac.norm"))
gata4 = data.frame(fread("overlap_GATA4/ATAC_summit.2k.overlap_GATA4.distal.bed"))


a2 = a[which(a$Geneid %in% gata4$V4),]
b2 = b[which(b$Geneid %in% gata4$V4),]


cori = sapply(1:nrow(a2),function(i){ cor(as.numeric(a2[i,7:12]),1:6)})
as2 = a2[order(-cori),c(1,7:12)]
bs2 = b2[order(-cori),c(1,7:12)]
rownames(as2) = rownames(bs2) = 1:nrow(as2)
am = melt(as.matrix(as2[,-1]))
bm = melt(as.matrix(bs2[,-1]))

ggplot(am ) + geom_tile(aes(x=Var2,y=Var1,fill=log2(value))) + 
  scale_fill_gradientn(colors=c("white","white","red"),values=c(0,0.5,1))

ggplot(bm ) + geom_tile(aes(x=Var2,y=Var1,fill=log2(value))) + 
  scale_fill_gradientn(colors=c("white","white","red"),values=c(0,0.5,1))




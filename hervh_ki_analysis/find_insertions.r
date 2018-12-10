options(scipen=99)
BIN_SIZE = BIN_SIZE
setwd("../../analysis/hervh_ki/")

name = "herv_ki1"
name=  "herv_ko1"

for (name in c("herv_ki1","herv_ki2","herv_ko1","herv_ko2")){

a=read.table(paste0(name,".interact.valid_pairs_1.txt"))
b=read.table(paste0(name,".interact.valid_pairs_2.txt"))

a1 = a[,c(7,8)] 
b1 = b[,c(3,4)]
colnames(a1) = colnames(b1) = c("chr","start")
comb = rbind(a1,b1)
comb$bin = floor(comb$start/BIN_SIZE)*BIN_SIZE

#agg = table(paste0(comb$chr,":",comb$bin))
agg = aggregate(start~chr+bin,comb,function(x){length(x)})
agg = agg[order(-agg$start),]
agg$name = paste0(agg$chr,":",agg$bin)

out = agg[,c(1,2,2,3)]
out[,3] = out[,3]+BIN_SIZE
write.table(out,paste0(name,".pileup.bedGraph"),row.names=F,col.names=F,sep="\t",quote=F)


pdf(paste0(name,".pdf"),height=10,width=5)
print( ggplot(comb) +geom_bar(aes(x=bin)) + scale_y_log10() + 
  geom_vline(data=agg[1:20,], aes(xintercept=bin),color='red') + 
  facet_grid(chr~.) )
dev.off()
}


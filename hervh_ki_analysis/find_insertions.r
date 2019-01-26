options(scipen=99)
BIN_SIZE = 10000
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
comb_list = {}
for (i in c(-4:4)){
  comb_ex = comb
  comb_ex$bin = comb_ex$bin + BIN_SIZE * i

  comb_list[[i+5]] = comb_ex
  }
comb = do.call(rbind,comb_list)
comb$chr = factor(comb$chr,levels=paste0("chr",c(1:22,"X","Y")))
comb = comb[!is.na(comb$chr),]

#agg = table(paste0(comb$chr,":",comb$bin))
agg = aggregate(start~chr+bin,comb,function(x){length(x)})
agg = agg[order(-agg$start),]
agg$name = paste0(agg$chr,":",agg$bin)

out = agg[,c(1,2,2,3)]
out[,3] = out[,3]+BIN_SIZE
out = out[order(out$chr,out$bin),]
write.table(out,paste0(name,".pileup.bedGraph"),row.names=F,col.names=F,sep="\t",quote=F)

chr.len = aggregate(start~chr,comb,max)

pdf(paste0(name,".w5.pdf"),height=10,width=7)
print( 
  ggplot() + geom_rect(data=chr.len,
        aes(xmin=0,ymin=0,xmax=start,ymax=100),fill=NA,color="black") +
  geom_bar(data=comb,aes(x=bin)) + 
  scale_y_continuous(name="",breaks=c(0,100),limits=c(0,100)) + 
  facet_grid(chr~.,switch="y") +
  theme(
    panel.background = element_rect(fill = NA, colour = NA),
    panel.grid = element_blank(),
    axis.text.x = element_blank(),
    strip.text.y = element_text(angle = 180),
    axis.ticks.x=element_blank()
  )

  )
dev.off()
}


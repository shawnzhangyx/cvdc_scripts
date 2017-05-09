setwd("../../analysis/h3k27me3_loop/")

l1 = data.frame(fread("k27.loop.overlap.txt"))
l2 = data.frame(fread("k27.loop.rev.overlap.txt"))
k27 = data.frame(fread("../../data/chipseq/counts/H3K27me3.rpkm"))

l1$name = paste(l1$V5,l1$V6,l1$V9)
l2$name = paste(l2$V5,l2$V9,l2$V6)

common = l1$name[which(l1$name %in% l2$name)]

l1f = l1[l1$name %in% common,c(4:10,12)]
l2f = l2[l2$name %in% common,c(4,12)]

mm = merge(l1f,l2f, by="name")
k27.out = k27[k27$Geneid %in% c(mm$V4.x,mm$V4.y),]
loops = mm[,c("V5","V6","V9")]
loops = loops[!duplicated(loops),]


system("mkdir k27Tok27LoopValuesAndCorrelation/")
write.table(k27.out, "k27Tok27LoopValuesAndCorrelation/k27.rpkm.txt",row.names=F,sep='\t',quote=F)
write.table(loops,"k27Tok27LoopValuesAndCorrelation/loops.txt",row.names=F,col.names=F,sep='\t',quote=F)

write.table(mm, "k27Tok27LoopValuesAndCorrelation/k27.loop.k27.txt",row.names=F,sep='\t',quote=F)


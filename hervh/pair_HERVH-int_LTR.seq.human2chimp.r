setwd("../../analysis/hervh/multi_seq_aln")

a=read.delim("HERVH-int.liftover.PanTro5.txt",header=F,stringsAsFactors=F)
b=read.delim("../hervh.sorted_rnaseq.name.bed",header=F,stringsAsFactors=F)

#d = a$V4[a$V4 %in% b$V4]

for (i in 1:nrow(a)) {
  print(i)
  am = a[i,]
  am$V4 = paste0(am$V4,".Chimp")
  bm = b[which(b$V4 ==a$V4[i]),]
  bm$V4 = paste0(bm$V4,".Human")
  write.table(am, paste0("HERVH_int_human_chimp/",am$V4,".bed"),row.names=F,col.names=F,sep='\t',quote=F)
  write.table(bm, paste0("HERVH_int_human_chimp/",bm$V4,".bed"),row.names=F,col.names=F,sep='\t',quote=F)
}


a=read.delim("5P_LTRs.liftover.PanTro5.bed",header=F,stringsAsFactors=F)
b=read.delim("5P_LTRs.Human.name.bed",header=F,stringsAsFactors=F)


for (i in 1:nrow(a)) {
  print(i)
  am = a[i,]
  am$V4 = paste0(am$V4,".Chimp")
  bm = b[which(b$V4 ==a$V4[i]),]
  bm$V4 = paste0(bm$V4,".Human")
  write.table(am, paste0("LTR_5P_human_chimp/",am$V4,".bed"),row.names=F,col.names=F,sep='\t',quote=F)
  write.table(bm, paste0("LTR_5P_human_chimp/",bm$V4,".bed"),row.names=F,col.names=F,sep='\t',quote=F)
}

a$len1 = a$V3-a$V2
b$len2 = b$V3-b$V2
a$len2 = b$len2[match(a$V4,b$V4)]

ggplot(a) + geom_point(aes(x=len1,y=len2)) #+ geom_abline(0,1)

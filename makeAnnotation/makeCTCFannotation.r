setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/annotation/ctcf")

a=data.frame(fread("ctcf_preidcted_from_CTCFBSDB.txt"))
h= a[which(a$Species=="Human"),]
h2 = h[,3]
h1 = h[,1]
chr = sub("(chr.*):(.*)-(.*)","\\1",h2)
start = sub("(chr.*):(.*)-(.*)","\\2",h2)
end = sub("(chr.*):(.*)-(.*)","\\3",h2)
out = data.frame(chr,start,end,h1)

write.table(out,"ctcf_human_predicted_from_CTCFBSDB.bed",row.names=F,col.names=F,sep='\t',quote=F)



a=read.table("anchors/anchors.uniq.30k.num_loops.txt")

out = list()
#for( i in 1:nrow(a)){
while ( nrow(a)>0 ) {
  print(c(nrow(a),length(out)))
  tmp = a[1,]
  idx = which(a$V1==tmp$V1 & abs(a$V2-tmp$V2) <=20000)
  a = a[-idx,]
  out[[length(out)+1]] = tmp
}
out2 = do.call(rbind,out)

write.table(out2,"anchors/anchors.uniq.30k.num_loops.red.txt",row.names=F,col.names=F,sep='\t',quote=F)

tss = read.table("overlap_anchors_to_features/anchor.gene_tss.unique.txt")
a=read.table("anchors/anchors.uniq.30k.num_loops.txt")
out3 = merge(a,tss,by=c("V1","V2","V3"))
out3 = out3[order(-out3[,4]),]
out3 = out3[!duplicated(out3$V7),]
write.table(out3,"anchors/anchors.uniq.30k.num_loops.genes.txt",row.names=F,col.names=F,sep='\t',quote=F)

genes = unique(out3[out3[,4]>3,8])
write.table(genes,"anchors/genes_num_loops3.txt",row.names=F,quote=F,col.names=F)


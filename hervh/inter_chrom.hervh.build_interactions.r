a=read.delim("D00.rna_seq.ranked_by_rpkm.v2.bed",header=F)
a = a[grep("chr",a$V4),]
# leave only HERVH expression RPKM >1. 
a2 = a[which(a$V7 >=1),]

# sort the peak location wrt to chromosome and location
a2$loc = floor(a2$V2/1e4) * 1e4

a3 = a2[,c(1,8)]
a3$V1 = factor(a3$V1, levels=paste0("chr",c(1:22,"X")))
a3 = a3[order(a3$V1,a3$loc),]

out_dict = list()
for (i in 1:nrow(a3)){
  print(i)
 for (j in (i+1):nrow(a3)) {
   print(j)
   out_dict[[length(out_dict)+1]]  = cbind(a3[i,],a3[j,])
   
 }
  
}

out = do.call(rbind, out_dict)

colnames(out) = c("chr1","x1","chr2","y1")
out$x2 = out$x1+1e4
out$y2 = out$y1+1e4

out = out[,c(1,2,5,3,4,6)]


write.table(out,"inter_chrom_int/hervh.pairs.rpkm_gt1.txt",row.names=F,sep="\t",quote=F)


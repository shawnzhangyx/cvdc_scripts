setwd("../../analysis/hervh")

a=read.delim("hervh_regulated_gene_TADs/hervh.dyn.overlap.TADs.v2.txt",header=F)
b=read.delim("hervh.dynamicBoundaries.for_deeptools.bed",header=F)


a1 = a[order(a$V4,a$V7),]
a1 = a1[!duplicated(a1$V4),]
a2 = a[order(a$V4,-a$V8),]
a2 = a2[!duplicated(a2$V4),]

out = merge(a1[,c(1,2,3,4,7)],a2[,c(1,2,3,4,8)],by=c("V1","V2","V3","V4"))
out$strand = b$V6[match(out$V4,b$V4)]
out$mid = ifelse(out$strand=="+",out$V3-50000,out$V2+50000)
out$p5s = ifelse(out$strand=="+",out$V7,out$mid)
out$p5e = ifelse(out$strand=="+",out$mid,out$V8)
out$p3s = ifelse(out$strand=="+",out$mid,out$V7)
out$p3e = ifelse(out$strand=="+",out$V8,out$mid)

 out$p3e = ifelse( out$p3e-out$p3s < 0, out$p3s + 1000, out$p3e)
 out$p5e = ifelse( out$p5e-out$p5s < 0, out$p5s + 1000, out$p5e)



write.table(out[,c(1,9,10)],"hervh_regulated_gene_TADs/5p_TAD.bed",row.names=F,col.names=F,sep='\t',quote=F)
write.table(out[,c(1,11,12)],"hervh_regulated_gene_TADs/3p_TAD.bed",row.names=F,col.names=F,sep='\t',quote=F)


############ extend to only 500kb. 

out$p5s = ifelse(out$strand=="+",out$mid-5e5,out$mid)
out$p5e = ifelse(out$strand=="+",out$mid,out$mid+5e5)
out$p3s = ifelse(out$strand=="+",out$mid,out$mid-5e5)
out$p3e = ifelse(out$strand=="+",out$mid+5e5,out$mid)



write.table(out[,c(1,9,10)],"hervh_regulated_gene_TADs/5p_500kb.bed",row.names=F,col.names=F,sep='\t',quote=F)
write.table(out[,c(1,11,12)],"hervh_regulated_gene_TADs/3p_500kb.bed",row.names=F,col.names=F,sep='\t',quote=F)




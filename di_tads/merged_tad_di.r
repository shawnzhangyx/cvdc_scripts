a=read.delim("combined_tads.uniq.gt1.txt")

di= data.frame(fread("directionality_data/combined.matrix"))
# left di 
l1 = di[match( paste(a$chr1,a$x1),paste(di$chrom,di$start)),]
l2 = di[match( paste(a$chr1,a$x1+40000*1),paste(di$chrom,di$start)),]
l3 = di[match( paste(a$chr1,a$x1+40000*2),paste(di$chrom,di$start)),]
lc = l1[,4:15]+l2[,4:15]+l3[,4:15]
# right di
r1 = di[match( paste(a$chr1,a$x2-40000*1),paste(di$chrom,di$start)),]
r2 = di[match( paste(a$chr1,a$x2-40000*2),paste(di$chrom,di$start)),]
r3 = di[match( paste(a$chr1,a$x2-40000*3),paste(di$chrom,di$start)),]
rc = r1[,4:15]+r2[,4:15]+r3[,4:15]

lmax = sapply(1:nrow(lc),function(i){ max(lc[i,])-min(lc[i,])})
rmax = sapply(1:nrow(rc),function(i){ max(rc[i,])-min(rc[i,])})


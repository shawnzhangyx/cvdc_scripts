input = commandArgs(trailing=T)[1]

#a=read.delim("chr3.d00.rep1.enriched.txt")
a=read.delim(input)

a = a[order(a$p_local_b2r),]
a$FC = a$raw/a$exp_local_b2raw

loops = list()
while( nrow(a)>0) {

centroid = a[1,]
# nearby pixels
nearby_idx = which( abs(a$x-centroid$x)<=20000 & abs(a$y-centroid$y) <=20000)
centroid$num_collapse = length(nearby_idx)
loops[[length(loops)+1]] = centroid
a = a[-nearby_idx,] 
}
loops = do.call(rbind,loops)

#write.table(loops,"chr3.d00.rep1.enriched.merged.txt",row.names=F,sep='\t',quote=F)
write.table(loops,paste0(input,".merged"),row.names=F,sep='\t',quote=F)


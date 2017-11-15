chrom = read.table("~/annotations/hg19/hg19.fa.fai",stringsAsFactors=F)
chrom = chrom[which(chrom$V1 %in% paste0("chr",c(1:22,"X"))),]

N = 10

pos = 0
for (i in 1:nrow(chrom)){ 
  chrom$V3[i] = pos
  pos = pos+ chrom$V2[i]
  }

list = read.table("D00.unique.tads.inc25k.bed")
widths = rep(list$V3-list$V2,N)

#for (w in widths ){

rand = runif(length(widths),min=0,max=chrom[nrow(chrom),3])

find_chr = function(num){
  tail(which(chrom$V3< num),1)
  }

idx = sapply(1:length(rand), function(x){ find_chr(rand[x])})

chr = chrom[idx,1]
start = floor(rand - chrom[idx,3])
end = start + widths


write.table(data.frame(chr,start,end),"D00.unique.tads.random_10x.bed",row.names=F,
  col.names=F, sep='\t',quote=F)


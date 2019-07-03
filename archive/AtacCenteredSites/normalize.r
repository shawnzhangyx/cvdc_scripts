
setwd("../../analysis/atacCenteredSites/counts")

mark="ATAC"
for ( mark in c("ATAC","H3K27ac","H3K4me1")){
  dat = data.frame(fread(paste0(mark,".counts")))
  b = read.delim(paste0(mark,".counts.summary"))
  total = colSums(b[,-1])
  dat[,7:12] = sweep(dat[,7:12],2,total,"/") *1e6
  write.table(dat,paste0(mark,".norm"),row.names=F,sep='\t',quote=F)
}


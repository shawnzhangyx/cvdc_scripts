setwd("../../analysis/di_tads.10k.2M.d0-5")

a= data.frame(fread("boundaries/boundary.all.txt"))

colnames(a) = c("chr1","x1","sample")
# a = a[order(-a$score),]

combined = list()
while ( nrow(a)>0){
tad = a[1,]
#x1 = ifelse(a$x1
idx = which(  a$chr1 == tad$chr1 & a$x1==tad$x1 )
tad$samples = paste(sort(a[idx,"sample"]),collapse=",")
len = length(combined)
print(len)
combined[[len+1]] = tad
a = a[-idx,]
}

tads = do.call(rbind,combined)
library(stringr)
tads$num_calls = str_count(tads$samples,",")+1

write.table(tads[,c(1,2,4,5)],"boundaries/combined_boundary.uniq.txt",row.names=F,sep='\t',quote=F)




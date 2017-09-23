setwd("../../analysis/tads")

a= data.frame(fread("combined_tads.raw.sorted.txt"))

a = a[order(-a$score),]

combined = list()
while ( nrow(a)>0){
tad = a[1,]
#x1 = ifelse(a$x1
idx = which(  a$chr1 == tad$chr1 & abs(a$x1-tad$x1)<=50000 & abs(a$x2-tad$x2)<=50000 )
tad$samples = paste(sort(sub("(.{8}).10000_blocks","\\1",a[idx,"sample"])),collapse=",")
len = length(combined)
print(len)
combined[[len+1]] = tad
a = a[-idx,]
}

tads = do.call(rbind,combined)
library(stringr)
tads$num_calls = str_count(tads$samples,",")+1

tads$chr1 = paste0("chr",tads$chr1)
tads$chr2 = paste0("chr",tads$chr2)


write.table(tads,"combined_tads.uniq.txt",row.names=F,sep='\t',quote=F)
write.table(tads[which(tads$num_calls>1),],"combined_tads.uniq.gt1.txt",row.names=F,sep='\t',quote=F)



setwd("../../analysis/customLoops")

a= data.frame(fread("combined_loops.raw.sorted.txt"))
a = a[order(a$p_local_b2r),]


combined = list()
while ( nrow(a)>1){
loop = a[1,]
#x1 = ifelse(a$x1
idx = which(  a$chr == loop$chr & abs(a$x-loop$x)<=30000 & abs(a$y-loop$y)<=30000 )
loop$samples = paste(sort(unique(sub("(.{8}).loops","\\1",a[idx,"sample"]))),collapse=",")
left = nrow(a)
len = length(combined)
print(c(left,len))
combined[[len+1]] = loop
a = a[-idx,]
}

loops = do.call(rbind,combined)
library(stringr)
loops$num_calls = str_count(loops$samples,",")+1

write.table(loops,"combined_loops.uniq.txt",row.names=F,sep='\t',quote=F)
write.table(loops[which(loops$num_calls>1),],"combined_loops.uniq.gt1.txt",row.names=F,sep='\t',quote=F)

juicer = loops[which(loops$num_calls>1),c(1,2,2,1,3,3)]
colnames(juicer) = c("chr1","x1","x2","chr2","y1","y2")
juicer$x2 = juicer$x1+10000
juicer$y2 = juicer$y1+10000
juicer$color = "0,0,0"
write.table(juicer,"combined_loops.uniq.gt1.juicer.txt",row.names=F,sep='\t',quote=F)


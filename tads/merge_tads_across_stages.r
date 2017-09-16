setwd("../../analysis/tads")
a=data.frame(fread("combined_tads.grouped.txt",stringsAsFactors=F))
#options(scipen=99)
a$sample = substr(a$sample,1,8)

#x1 = aggregate(cbind(x1,y1)~grp1+grp2,a,FUN=median)
pos = aggregate(cbind(x1,x2)~grp1+grp2,a,FUN=median)
chr = aggregate(chr1~grp1+grp2,a,FUN=function(vec){vec[1]})
sample = aggregate(sample~grp1+grp2,a,FUN=function(vec){paste(sort(vec),collapse=",")})
combined = merge(chr,pos,by=c("grp1","grp2"))
combined = combined[order(combined$chr1,combined$x1,combined$x2),]
combined$x1 = floor(combined$x1/10000)*10000
combined$x2 = floor(combined$x2/10000)*10000
combined$chr2 = combined$chr1
combined$y1 = combined$x1 
combined$y2 = combined$x2
combined$color = "0,0,0"
combined = merge(combined,sample,by=c("grp1","grp2"))
out = combined[,c(3:10)]
out = out[!duplicated(out),]
write.table(out,"combined_tads.uniq.txt",row.names=F,quote=F,sep='\t')


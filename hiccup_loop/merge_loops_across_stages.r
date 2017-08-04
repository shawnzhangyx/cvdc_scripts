setwd("../../analysis/hiccup_loops")
a=data.frame(fread("combined_loops.grouped.txt",stringsAsFactors=F))
options(scipen=99)


x1 = aggregate(cbind(x1,y1)~grp1+grp2,a,FUN=median)
chr = aggregate(chr1~grp1+grp2,a,FUN=function(vec){vec[1]})
combined = merge(chr,x1,by=c("grp1","grp2"))
combined = combined[order(combined$chr1,combined$x1,combined$y1),]
combined$chr2 = combined$chr1
combined$x1 = floor(combined$x1/10000)*10000
combined$y1 = floor(combined$y1/10000)*10000
combined$x2 = combined$x1+10000
combined$y2 = combined$y1+10000
combined$color = "0,0,0"
out = combined[,c(3,4,7,6,5,8,9)]
write.table(out,"combined_loops.uniq.txt",row.names=F,quote=F,sep='\t')


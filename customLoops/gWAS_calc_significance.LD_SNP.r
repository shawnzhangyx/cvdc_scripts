setwd("../../analysis/customLoops/gWAS")

argv = commandArgs(trailing=T)
## f1 is file for total coverage of genome. 
f1 =argv[1]
## f2 is file of gWAS SNP overlapped.  
f2 =argv[2]
## f3 is the output file
f3 =argv[3]
#cov = read.table("anchors.merged.bed")
cov = read.table(f1)
chrom.size = read.table("../../../data/annotation/hg19.chrom.sizes")
prob = sum(cov$V3-cov$V2)/sum(as.numeric(chrom.size$V2[1:24]))

b =data.frame(fread("GWAS_Catolog.LD.SNP.hg19.bed"))
#a =data.frame(fread("gwas_overlaped.txt"))
a = data.frame(fread(f2))

#b.red = b[!duplicated(b[,5:6]),]
#a.red = a[!duplicated(a[,9:10]),]
#total = aggregate(V5~V6,b.red,length)
#tested = aggregate(V9~V10,a.red,length)
#combined = merge(total,tested,by.x="V6",by.y="V10")
#combined$pval = sapply(1:nrow(combined), 
#  function(i){ binom.test(x=combined$V9[i],
#                          n=combined$V5[i], p=prob)$p.value })

b.red = b[!duplicated(b[,c(4,6)]),]
a.red = a[!duplicated(a[,c(8,10)]),]
total = aggregate(V4~V6,b.red,length)
tested = aggregate(V8~V10,a.red,length)
combined = merge(total,tested,by.x="V6",by.y="V10")
combined$pval = sapply(1:nrow(combined),
  function(i){ binom.test(x=combined$V8[i],
                          n=combined$V4[i], p=prob)$p.value })



combined=combined[order(combined$pval),]

write.table(combined,f3,row.names=F,quote=F,sep='\t')




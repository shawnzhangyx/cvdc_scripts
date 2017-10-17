setwd("../../analysis/customLoops/gWAS")

argv = commandArgs(trailing=T)
f1 =argv[1]
f2 =argv[2]
f3 =argv[3]
#cov = read.table("anchors.merged.bed")
cov = read.table(f1)
chrom.size = read.table("../../../data/annotation/hg19.chrom.sizes")
prob = sum(cov$V3-cov$V2)/sum(as.numeric(chrom.size$V2[1:24]))

b =data.frame(fread("GWAS_Catolog_hg19.bed"))
#a =data.frame(fread("gwas_overlaped.txt"))
a = data.frame(fread(f2))

b.red = b[!duplicated(b[,4:5]),]
#a.red = a[!duplicated(a$V7,a$V8),]
a.red = a[!duplicated(a[,7:8]),]

total = aggregate(V4~V5,b.red,length)
tested = aggregate(V7~V8,a.red,length)

combined = merge(total,tested,by.x="V5",by.y="V8")

combined$pval = sapply(1:nrow(combined), 
  function(i){ binom.test(x=combined$V7[i],
                          n=combined$V4[i], p=prob)$p.value })


combined=combined[order(combined$pval),]

write.table(combined,f3,row.names=F,quote=F,sep='\t')




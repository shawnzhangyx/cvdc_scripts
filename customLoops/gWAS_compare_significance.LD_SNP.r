setwd("../../analysis/customLoops/gWAS")

argv = commandArgs(trailing=T)
## f1 is file for total coverage of genome. 
f1 ="anchors.clusters3-5.ATAC.bed" #argv[1]
## f2 is file of gWAS SNP overlapped.  
f2 ="gwas_overlaped.clusters3-5.ATAC.txt" #argv[2]
## f1c is ifle for control coverage
f1c = "anchors.nondynamic.ATAC.bed" # argv[3]
f2c = "gwas_overlaped.nondynamic.ATAC.txt" #argv[4]
## f3 is the output file
f3 ="LD_SNP.clustesr2-5.vs.nondynamic.txt"  #argv[5]
#cov = read.table("anchors.merged.bed")
cov = read.table(f1)
cov= cov[!duplicated(cov$V4),]
chrom.size = read.table("../../../data/annotation/hg19.chrom.sizes")
prob1 = sum(cov$V3-cov$V2)/sum(as.numeric(chrom.size$V2[1:24]))
cov = read.table(f1c)
cov= cov[!duplicated(cov$V4),]
chrom.size = read.table("../../../data/annotation/hg19.chrom.sizes")
prob2 = sum(cov$V3-cov$V2)/sum(as.numeric(chrom.size$V2[1:24]))


b =data.frame(fread("GWAS_Catolog.LD.SNP.hg19.bed"))
a = data.frame(fread(f2))
a2 = data.frame(fread(f2c))

b.red = b[!duplicated(b[,c(4,6)]),]
a.red = a[!duplicated(a[,c(8,10)]),]
a2.red = a2[!duplicated(a2[,c(8,10)]),]


total = aggregate(V4~V6,b.red,length)
tested = aggregate(V8~V10,a.red,length)
tested2 = aggregate(V8~V10,a2.red,length)

combined1 = merge(total,tested,by.x="V6",by.y="V10")
combined = merge(combined1,tested2,by.x="V6",by.y="V10")

combined$pval = ppois(combined[,3], combined[,4]*prob1/prob2,lower.tail=F)


#combined$pval = sapply(1:nrow(combined),
#  function(i){ binom.test(x=combined$V8[i],
#                          n=combined$V4[i], p=prob)$p.value })



combined=combined[order(combined$pval),]

write.table(combined,f3,row.names=F,quote=F,sep='\t')




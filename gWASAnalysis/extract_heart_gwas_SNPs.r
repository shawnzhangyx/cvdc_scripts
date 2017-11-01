setwd("../../data/gWAS")

a=read.delim("GWAS_Catolog_all_09282017.red.tsv",header=F)

b=read.delim("LD_SNP_SNAP.hg19.red.bed",header=F)

heart_traits = c(
  "Atrial fibrillation",
  "Cardiac repolarization",
  "Coronary heart disease",#
  "Conotruncal heart defects",#
  "Congenital left-sided heart lesions",
  "Congenital heart disease",
  "Congenital heart malformation",#
  "Heart failure",
  "Mortality in heart failure",#
  "PR interval",
  "QRS duration",
  "QT interval",
  "Sudden cardiac arrest")

snps = a[which(a$V2 %in% heart_traits),]
ldsnp = b[which(b$V5 %in% snps$V1),]
ldsnp$trait = snps$V2[match(ldsnp$V5,snps$V1)]
write.table(ldsnp,"heartGWAS.LD_SNP.bed",row.names=F,col.names=F,quote=F,sep='\t')


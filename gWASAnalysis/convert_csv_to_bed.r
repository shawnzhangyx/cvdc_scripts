setwd("../../data/gWAS/")
library(data.table)

a=read.delim("GWAS_Catolog_all_09282017.tsv",stringsAsFactors=F)
#b=a[,c("DISEASE.TRAIT","CHR_ID","CHR_POS","REPORTED.GENE.S.","MAPPED_GENE","SNPS")]
b=a[,c("SNPS","DISEASE.TRAIT","CHR_ID","CHR_POS")]
b=b[grep("rs",b$SNPS),]
library(stringr)
b$count = str_count(b$SNPS,"rs")
b = b[which(b$count==1),]
b$SNPS = sub(".*(rs[[:digit:]]*).*","\\1",b$SNPS)
b=b[order(b$SNPS),]
b=b[!b$CHR_ID=="",]
write.table(b[,1:2],"GWAS_Catolog_all_09282017.red.tsv",
  row.names=F,col.names=F,sep='\t',quote=F)
write.table(cbind(paste0("chr",b$CHR_ID,"\t",b$CHR_POS,"\t",as.numeric(b$CHR_POS)+1),b$SNPS),"LOC",quote=F,row.names=F,col.names=F,sep='\t')

#a=data.frame(fread("heartgwasLDcommonSNPrightorder.bed.csv"))
#lead = a[,c(2,3,4,1,5)]
#lead = lead[!duplicated(lead),]
#write.table(a[,c(7,8,9,6,1,2,3,4,5)],"heartgwasLDcommonSNP.bed",row.names=F,col.names=F,sep='\t',quote=F)


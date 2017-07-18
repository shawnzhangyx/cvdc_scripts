setwd("../../data/wgsData")

load("wgs_denovo_case_control_20170531.RData")

out = hms_wgs_case_denovo[,c(2,3)]
out$X.CHROM = paste0("chr",out$X.CHROM)
write.table(cbind(out,out$POS+1), "wgs_denovo_case.bed",row.names=F,col.names=F,sep='\t',
  quote=F)


#test = hms_wgs_case_denovo[,c("X.CHROM","POS","uniqueVarID","REF","SNPEFFMAX_GENE_NAME")]



a=read.delim("../../data/gWAS/gWAS.overlap_atac_distal.txt",header=F,stringsAsFactors=F)
b=fread("../../data/GTEX/GTEx_Analysis_2016-01-15_v7_WholeGenomeSeq_635Ind_PASS_AB02_GQ20_HETX_MISS15_PLINKQC.lookup_table.txt")
rs = unique(a$V8)
id = b$variant_id[match(rs, b$rs_id_dbSNP147_GRCh37p13)]

write.table(cbind(rs,id),"../../analysis/GTEX/rs_id",row.names=F,col.names=F,quote=F)

d = fread("../../data/GTEX/GTEx_Analysis_v7.metasoft.txt")


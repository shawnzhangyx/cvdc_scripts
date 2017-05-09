setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/enhancer_promoter_interaction/enhancer2DistalValuesAndCorrelation/")
a=read.delim("loop.gene.atac.txt")
a = a[,-1]
a = a[!duplicated(a),]
colnames(a) = c("gene","ATAC.peak")

atac = data.frame(fread("../../../data/atac/peaks/atac_distal_peaks.overlap_SNP.bed"))
atac.snp.agg = aggregate(V8~V4,atac, paste,collapse=",")
atac.snp.agg$V8 = as.character(atac.snp.agg$V8)
atac.gwas.agg = aggregate(V9~V4,atac, function(x){paste(unique(x),collapse=",")})
atac.m = atac[match(a$ATAC.peak,atac$V4),]
a$choord = paste(atac.m$V1,atac.m$V2,atac.m$V3)
a$snp = atac.snp.agg[match(a$ATAC.peak, atac.snp.agg$V4),"V8"]
a$gwas = atac.gwas.agg[match(a$ATAC.peak, atac.gwas.agg$V4),"V9"]

gannot = data.frame(fread("~/annotations/refseqGene/H_sapiens/Homo_sapiens.gene_info"))
a$gene.description = gannot[match(a$gene, gannot$Symbol), "description"]
summary = data.frame(fread("~/annotations/refseqGene/H_sapiens/ncbi_gene_summary.txt",header=F))

a$summary = summary[match(a$gene,summary$V1),"V2"]

write.csv(a,"gene2distalEnhancerSNP.csv",row.names=F)



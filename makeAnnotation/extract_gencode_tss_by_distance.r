library(data.table)
if (length(commandArgs(trailing=T))!=1){
  print("%prog distance-cut-off-in-bps")
  exit(1)
}

DISTANCE_CUT_OFF = as.numeric(commandArgs(trailing=T)[1])


file = data.frame(fread("~/annotations/hg19/gencode.v19.annotation.gtf",skip=5))
#conv=file[which(file$V3=="gene"),]
conv=file[which(file$V3=="transcript"),]

#conv=conv[which(conv$V2=="ENSEMBL"),]

get_gene_id = function(obj){
temp = strsplit(obj,";")[[1]][1]
gene_id = strsplit(temp,"\"")[[1]][2]
gene_id
}

get_gene_symbol = function(obj){
temp = strsplit(obj,";")[[1]][5]
gene_name = strsplit(temp,"\"")[[1]][2]
gene_name
}

get_gene_type = function(obj){
temp = sub('.* gene_type "(.*?)".*','\\1',obj)
temp
}

#conv$gene_id = sapply(conv$V9,get_gene_id)
#conv$gene_id = gsub('\\..*','',conv$gene_id)
conv$symbol = sapply(conv$V9,get_gene_symbol)
conv$gene_type = sapply(conv$V9,get_gene_type)
#conv = conv[which(conv$gene_type ==
conv = conv[,c(1,4,5,10,6,7)]
#conv = conv[,-c(2,3)]
colnames(conv) = c("chr","start","end","symbol","value","strand")
#write.table(conv,"gencode.v19.annotation.gene.body.bed",row.names=F,sep='\t',quote=F,col.names=F)
conv$start = ifelse(conv$strand=="+",conv$start-DISTANCE_CUT_OFF,conv$end-DISTANCE_CUT_OFF)
conv$end = conv$start+2*DISTANCE_CUT_OFF
conv$start[conv$start<0] =0
write.table(conv,paste0("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/annotation/gencode.v19.annotation.transcripts.tss", DISTANCE_CUT_OFF/1000, "k.bed"),row.names=F,sep='\t',quote=F,col.names=F)


setwd("../../analysis/hiccup_loops/overlap_features/")

#mark="H3K27ac"
for (mark in c("H3K27ac","H3K27me3","H3K4me1","H3K4me3")){
data = data.frame(fread(paste0("anchor.",mark,".txt")))
total = read.delim(paste0("../../../data/chipseq/stats/",mark,".mapped.total.txt"))
total = total[order(total$sample),]
colnames(data)[-c(1:6)] = sub("(.*?_.*?_.)_.*","\\1",colnames(data)[-c(1:6)])
data[,-c(1:6)] = sweep(data[,-c(1:6)],2,total$Total,"/")*10**6
write.table(data, paste0("anchor.",mark,".rpm.txt"),row.names=F,sep='\t',quote=F)
}

mark="atac"
data = data.frame(fread(paste0("anchor.",mark,".txt")))
total = read.delim(paste0("../../../data/atac/stats/",mark,".mapped.total.txt"))
total = total[order(total$sample),]
data[,-c(1:6)] = sweep(data[,-c(1:6)],2,total$Total,"/")*10**6
colnames(data)[-c(1:6)] = sub("(.*)_sorted_nodup.30.bam","\\1",colnames(data)[-c(1:6)])
write.table(data, paste0("anchor.",mark,".rpm.txt"),row.names=F,sep='\t',quote=F)

mark="rnaseq"
data = data.frame(fread(paste0("anchor.",mark,".txt")))
total = read.delim(paste0("../../../data/rnaseq/stats/",mark,".mapped.total.txt"))
total = total[order(total$sample),]
colnames(data)[-c(1:6)] = sub("(.*).bam","\\1",colnames(data)[-c(1:6)])
data[,-c(1:6)] = sweep(data[,-c(1:6)],2,total$Total,"/")*10**6
write.table(data, paste0("anchor.",mark,".rpm.txt"),row.names=F,sep='\t',quote=F)


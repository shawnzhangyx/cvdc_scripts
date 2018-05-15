a=read.delim("hervh.dist.CTCF_peaks.txt",header=F)
a$name = paste0(a$V1,":",a$V2,"-",a$V3)
b=read.delim("herv.rnaseq.sorted.txt",header=F)
b$rank = rank(-b$V2)
a$rank = b$rank[match(a$name,b$V1)]


d = read.delim("TSSs.dist.CTCF_peaks.txt",header=F)
#e = read.delim("
d =d[order(-d$V5),]


setwd("../../analysis/di_tads.10k.2M/dynamic_bd/")

a=read.delim("../../customLoops/loops/loops.cpb.logFC.edger.final.cluster.txt")
a$chr = sub("(.*) (.*) (.*)","\\1",a$name)
a$start = as.numeric(sub("(.*) (.*) (.*)","\\2",a$name))
a$end = as.numeric(sub("(.*) (.*) (.*)","\\3",a$name))

b=read.table("d00.txt")

ovlp_list = list()

for(i in 1:nrow(b)){
print(i)
ol = a[which(a$chr== b$V1[i] & a$start < b$V2[i] & a$end > b$V2[i]),]
ovlp_list[[i]] = ol
}

out = do.call(rbind,ovlp_list)


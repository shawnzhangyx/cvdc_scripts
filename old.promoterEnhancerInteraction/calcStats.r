setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/enhancer_promoter_interaction")
a=data.frame(fread('loop.inter.tss.txt'))

a$loop = paste(a$V1, ifelse(a$V2 < a$V5, a$V2, a$V5), ifelse(a$V2 < a$V5, a$V5, a$V2))
length(unique(a$loop)) #191181


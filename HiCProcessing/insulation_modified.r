setwd("../../data/hic/insulation/")

args = commandArgs(trailing=T)
chr = args[1]
sample = args[2]
a=read.delim(paste0(sample,"/",chr,"_contacts.500.bedGraph"),header=F)

for(i in 1:nrow(a)){
  a$mean[i] = mean(a$V4[which(abs(a$V2-a$V2[i]) <=2.5e5)])
  }

a$ins = log2(a$V4/a$mean)
write.table(a[,c(1,2,3,6)],paste0(sample,"/",chr,".ins2.500.bedGraph"),row.names=F,col.names=F,sep='\t',quote=F)


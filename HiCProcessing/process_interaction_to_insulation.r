library(data.table)
options(scipen=99)

setwd("../../data/hic/")
res = 10e3
chr = 13
rang = 500e3

## input parameters 
chr = commandArgs(trailing=T)[1]
rang = as.numeric(commandArgs(trailing=T)[2])
sample=commandArgs(trailing=T)[3]

a=data.frame(fread(paste0("matrix/",sample,"/",chr,"_10000.txt")))

## resolution

mi = min(a$V1)
ma = max(a$V1)

position = seq(mi+rang,ma-rang,res)
contacts = NA

library(doParallel)
registerDoParallel(cores=8)

out = foreach(i = 1:length(position)) %dopar% {
  print(i)
  pos = position[i]
  tmp = a$V3[which( a$V1< pos & a$V1> pos-rang & a$V2 > pos & a$V2 < pos+rang)]
  su = sum(tmp,na.rm=T)
  le = length(tmp)
  c(su,le)
}

contacts = do.call(rbind,out)

dat = data.frame(position,contacts)
colnames(dat) =c("position","contacts","num")

write.table(cbind(chr,dat$position,dat$position+res,dat$contacts,dat$num),paste0("insulation/",sample,"/",chr,"_contacts.",rang/1e3,".bedGraph"),row.names=F,col.names=F,sep='\t',quote=F)

dat$ins = log2(dat$contacts/mean(dat$contacts))
dat  = dat[which(dat$ins != -Inf & dat$num > 0.5* (rang/res-1)**2),]

write.table(cbind(chr,dat$position,dat$position+res,dat$ins),paste0("insulation/",sample,"/",chr,"_ins.",rang/1e3,".bedGraph"),row.names=F,col.names=F,sep='\t',quote=F)


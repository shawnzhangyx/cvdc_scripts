sample = commandArgs(trailing=T)[1]
setwd("../../analysis/ab_compartments")
a = data.frame(fread("pc1_data/combined.matrix"))
colnames(a)[-c(1:3)] = readLines("../../data/hic/meta/names.txt")

#pc1 = ifelse(a[,which(colnames(a)==sample)]>0,1,-1)
dat = a[,c(1,which(colnames(a)==sample))]
dat[,2] = ifelse(dat[,2]>0,1,-1)

#chr1 = 1
#win1 = table(dat[which(dat[,1]==paste0("chr",chr1)),2])
#win2 = table(dat[which(dat[,1] %in% paste0("chr",2:20)),2])
win1 = win2 = table(dat[,2])
counts = c(win1[1]*win2[1], win1[1]*win2[2]+win1[2]*win2[1],win1[2]*win2[2])
for (chr1 in c(1:22,"X")){
  win1 = win2 = table(dat[which(dat[,1]==paste0("chr",chr1)),2])
  counts2 = c(win1[1]*win2[1], win1[1]*win2[2]+win1[2]*win2[1],win1[2]*win2[2])
  counts = counts-counts2
}


out=cbind(c("BB","AB","AA"),counts)

write.table(out,paste0("ab_contacts/trans.",sample,".ab.bins.txt"),row.names=F,col.names=F,sep="\t",quote=F)


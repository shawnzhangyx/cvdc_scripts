#sample="D00_HiC_Rep1"
sample = commandArgs(trailing=T)[1]
setwd("../../analysis/ab_compartments")
a = data.frame(fread("pc1_data/combined.matrix"))
colnames(a)[-c(1:3)] = readLines("../../data/hic/meta/names.txt")

#pc1 = ifelse(a[,c(4,5)]>0,1,-1)
#pc1 = (pc1[,1]+pc1[,2])/2
pc1 = ifelse(a[,which(colnames(a)==sample)]>0,1,-1)
names(pc1) = paste(a$V1,a$V2)

chr1 = 1
chr2 = 2
counts_list = list()
for (chr1 in 1:22){
  for (chr2 in (chr1+1):23){
if (chr2==23)chr2="X"
print(c(chr1,chr2))
dat = data.frame(fread(paste0("../../data/hic/matrix_raw/",sample,"/",chr1,"_",chr2,".50k.mat")))
dat$a1 = pc1[ match(paste0("chr",chr1," ",dat$V1), names(pc1))]
dat$a2 = pc1[ match(paste0("chr",chr2," ",dat$V2), names(pc1))]
dat$AB =dat$a1+dat$a2 #ifelse ( ifelse(dat$a1==1, 
counts= aggregate(V3~AB,dat,FUN=sum)
counts_list[[length(counts_list)+1]] = counts 
}
}

counts = do.call(rbind,counts_list)
out=aggregate(V3~AB,counts,sum)
out$AB= c("BB","AB","AA")
write.table(out,paste0("ab_contacts/trans.",sample,".ab.contacts"),row.names=F,col.names=F,sep="\t",quote=F)

#counts
#  AB     V3
#  1 -2 332304
#  2  0 652749
#  3  2 773906




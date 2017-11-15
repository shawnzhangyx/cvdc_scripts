#commandArgs
# input is a list of chromosome coordinates. 
lists = commandArgs(trailing=T)[1] # test
sample = commandArgs(trailing=T)[2] # "D00_HiC_Rep1"
outdir = commandArgs(trailing=T)[3] # "../../analysis/tads/oe_median/"
library(doParallel)
registerDoParallel(cores=16)


locations = read.table(lists,stringsAsFactors=F)
locations = locations[which(locations$V1 %in% paste0("chr",c(1:22,"X"))),]
# read in the sample OE first. 
dat = list()
chrs = unique(locations$V1)
#chrs = sub("chr","",unique(locations$V1))

for (chr in chrs){
  print(chr)
  dat[[chr]] = fread(paste0("../../data/hic/observed_expected/",sample,"/",sub("chr","",chr),"_10000.txt"))
  }

out_list = list()

out_list = foreach(row=1:nrow(locations)) %dopar% {
#for (row in 1:nrow(locations)){
print(row)
chr = locations[row,1]
center  = floor( locations[row,2] /10000) *10000

a = dat[[chr]]
value = NULL
for ( i in seq(-200000,200000,10000) ) 
{ 
#  print(i)
  pos = center + i 
before = pos-200000
after = pos+200000
mat = a[which(a$V1 >before & a$V1 <= pos & a$V2 >=pos & a$V2 < after),]
value = c(value,median(mat$V3) ) 
}
out_list[[length(out_list)+1]] = value
}

out = do.call(rbind,out_list)
write.table(out,paste0(outdir,basename(lists),".",sample,".txt"),row.names=F,col.names=F,sep='\t',quote=F)


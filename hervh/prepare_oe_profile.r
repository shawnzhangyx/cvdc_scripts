setwd("../../analysis/hervh")

lists="hervh.dynamicBoundaries.txt"
loc = read.table(lists,stringsAsFactors=F)$V1
chr = sub("(chr.*):(.*)-(.*)","\\1",loc)
start = as.numeric(sub("(chr.*):(.*)-(.*)","\\2",loc))
end = as.numeric(sub("(chr.*):(.*)-(.*)","\\3",loc))
locations = data.frame(chr,start,end,loc,stringsAsFactors=F)

sample="D00_HiC_Rep1"
for (sample in c("D00_HiC_Rep1","D02_HiC_Rep1","D05_HiC_Rep1")){
## read all chromosomes. 
dat = list()
chrs = unique(locations$chr)
for (chr in chrs){
print(chr)
dat[[chr]] = fread(paste0("../../data/hic/observed_expected/",sample,"/",sub("chr","",chr),"_10000.txt"))
}


library(doParallel)
registerDoParallel(cores=8)

out_list = list()
out_list = foreach(row=1:nrow(locations)) %dopar% {
print(row)
chr = locations[row,1]
center =locations[row,2]
#center  = floor( locations[row,2] /10000) *10000

a= dat[[chr]]
tmp = a[which( abs(a$V1-center) <2e5 & abs(a$V2-center) <2e5 ),]
#tmp$V3 = tmp$V3* 1/median(tmp$V3)
#tmp$loc = locations$loc[row]
tmp$center = center

out_list[[length(out_list)+1]] = tmp
}

out = do.call(rbind,out_list)

write.csv(out,paste0("oe_profile/",sample,".csv"),row.names=F)
}

# OE profile for non-boundary HERV-H
sample="D00_HiC_Rep1"
for (file in c("hervh_rnaseq_brackets/hervh.rank.051_100.bed","hervh_rnaseq_brackets/hervh.rank.101_150.bed")){
locations = read.delim(file,header=F,stringsAsFactors=F)[,1:4]
colnames(locations) = c("chr","start","end","loc")
chrs = unique(locations$chr)
dat = list()
for (chr in chrs){
print(chr)
dat[[chr]] = fread(paste0("../../data/hic/observed_expected/",sample,"/",sub("chr","",chr),"_10000.txt"))
}

library(doParallel)
registerDoParallel(cores=8)

out_list = list()
out_list = foreach(row=1:nrow(locations)) %dopar% {
print(row)
chr = locations[row,1]
center =locations[row,2]
#center  = floor( locations[row,2] /10000) *10000

a= dat[[chr]]
tmp = a[which( abs(a$V1-center) <2e5 & abs(a$V2-center) <2e5 ),]
#tmp$V3 = tmp$V3* 1/median(tmp$V3)
#tmp$loc = locations$loc[row]
tmp$center = center
out_list[[length(out_list)+1]] = tmp
}
out = do.call(rbind,out_list)
write.csv(out,paste0("oe_profile/D00.rank",sub(".*rank.(.*).bed","\\1",file),".csv"),row.names=F)
}


  




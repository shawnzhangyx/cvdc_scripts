setwd("../../analysis/hervh")

lists="liftover2mm10/hervh.dynamic.liftover2mm10.bed"
locations = read.table(lists,stringsAsFactors=F)
#chr = sub("(chr.*):(.*)-(.*)","\\1",loc)
#start = as.numeric(sub("(chr.*):(.*)-(.*)","\\2",loc))
#end = as.numeric(sub("(chr.*):(.*)-(.*)","\\3",loc))
#locations = data.frame(chr,start,end,loc,stringsAsFactors=F)
colnames(locations) = c("chr","start","end")

sample="../../../Bonev_et_cell_2017/rep1/observed_expected/"
## read all chromosomes. 
dat = list()
chrs = unique(locations$chr)

for (chr in chrs){
print(chr)
dat[[chr]] = fread(paste0(sample,sub("chr","",chr),"_10000.txt"))
}


library(doParallel)
registerDoParallel(cores=8)

out_list = list()
out_list = foreach(row=1:nrow(locations)) %dopar% {
print(row)
chr = locations[row,1]
center =(locations[row,2]+locations[row,3])/2
#center  = floor( locations[row,2] /10000) *10000

a= dat[[chr]]
tmp = a[which( abs(a$V1-center) <2e5 & abs(a$V2-center) <2e5 ),]
#tmp$V3 = tmp$V3* 1/median(tmp$V3)
#tmp$loc = locations$loc[row]
tmp$center = center

out_list[[length(out_list)+1]] = tmp
}

out = do.call(rbind,out_list)

write.csv(out,"liftover2mm10/mES_rep1.csv",row.names=F)



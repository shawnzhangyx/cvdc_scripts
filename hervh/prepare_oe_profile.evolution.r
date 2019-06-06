setwd("../../analysis/hervh")

lists.list = c("evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt","evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt","evolution_analysis/bonobo/HERVH-int.liftover.PanPan2.txt","evolution_analysis/marmoset/HERVH-int.liftover.CalJac3.txt","evolution_analysis/mouse/HERVH-int.liftover.Mm10.txt")
sample.list = c("../../data/monkey_data/chimp/chimp.cm/observed_expected/","../../data/monkey_data/chimp/chimp.mt/observed_expected/","../../data/monkey_data/bonobo/bonobo/observed_expected/","../../data/monkey_data/marmoset/marmoset/observed_expected/","../../../../datasets/Bonev_et_cell_2017/rep1/observed_expected/")
name.list = c("chimp","chimp.mt","bonobo","marmoset","mouse")

for (idx in 1:3){
#lists="evolution_analysis/chimp/HERVH-int.liftover.Pantro6.txt"
lists = lists.list[idx]
locations = read.table(lists,stringsAsFactors=F)
locations = locations[which(locations$V4 %in% paste0("HERVH",1:50)),]
name = name.list[idx]
#chr = sub("(chr.*):(.*)-(.*)","\\1",loc)
#start = as.numeric(sub("(chr.*):(.*)-(.*)","\\2",loc))
#end = as.numeric(sub("(chr.*):(.*)-(.*)","\\3",loc))
#locations = data.frame(chr,start,end,loc,stringsAsFactors=F)
colnames(locations) = c("chr","start","end")

#sample="../../data/monkey_data/chimp/chimp/observed_expected/"
sample = sample.list[idx]
## read all chromosomes. 
dat = list()
chrs = unique(locations$chr)

for (chr in chrs){
print(chr)
dat[[chr]] = fread(paste0(sample,sub("chr","",chr),"_10000.txt"))
}

dat.all = do.call(rbind, dat)
dat.all$dist = dat.all$V2-dat.all$V1
dat.subset = subset(dat.all,dist<500000)
oe.median = aggregate(V3~dist,dat.subset,median,na.rm=T)
write.csv(oe.median,paste0("evolution_analysis/",name,"/",name,"_median.csv"),row.names=F)

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
write.csv(out,paste0("evolution_analysis/",name,"/",name,"_oe.csv"),row.names=F)
}


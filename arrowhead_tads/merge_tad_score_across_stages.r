setwd("../../analysis/tads/arrowhead_test_list")
files = list.files(pattern="list_scores",full.names=T,recursive=T)
names = sub(".*(D.._HiC_Rep.).*","\\1",files)
dat = list()
for (file in files){
print(file)
dat[[file]] = data.frame(fread(file))[,c(1,2,3,8)]
}

out = Reduce(function(...)merge(...,by=c("chr1","x1","x2")),dat)
colnames(out) = c("chr","x1","x2",names)
write.table(out,"combined_tads.uniq.score.txt",row.names=F,sep='\t',quote=F)


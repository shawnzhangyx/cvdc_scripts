setwd("../../analysis/insulation_tads/insulation_score")
files = list.files(pattern="ins.txt")
names = sub(".*(D.._HiC_Rep.).*","\\1",files)
dat = list()
agg = list()
for (file in files){
print(file)
dat[[file]] = data.frame(fread(file))[,c(1,2,3,7)]
tmp = aggregate(V7~V1+V2+V3,dat[[file]],FUN=mean)
agg[[file]] =tmp
}

out = Reduce(function(...)merge(...,by=c("V1","V2","V3")),dat)
out2 = Reduce(function(...)merge(...,by=c("V1","V2","V3")),agg)

colnames(out) = colnames(out2) = c("chr","x1","x2",names)
write.table(out,"combined_tads.uniq.score.txt",row.names=F,sep='\t',quote=F)

write.table(out2,"../combined_tads.uniq.gt1.ins_mean.txt",row.names=F,sep='\t',quote=F)


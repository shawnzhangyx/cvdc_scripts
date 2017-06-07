setwd("../../analysis/tads/tad_calls")
allStages = c("D00","D02","D05","D07","D15","D80")

for (stage in allStages){
otherStages = allStages[allStages != stage]

a = read.delim(paste0(stage,"_replicated.TAD.txt"),header=F)
b.list = list()
for (o_stage in otherStages){
b.list[[length(b.list)+1]] = read.delim(paste0(o_stage,"_replicated.TAD.txt"),header=F)
}
b = do.call(rbind,b.list)

out.dict = list()
for (chr in c(1:22,"X")){
  tempb = b[which(b$V1==paste0("chr",chr)),]
  tempa = a[which(a$V1==paste0("chr",chr)),]
  min_distance = sapply(1:nrow(tempa), function(x){ min(abs(tempa[x,2]-tempb$V2)) })
  min_distance_idx = sapply(1:nrow(tempa), function(x){ which.min(abs(tempa[x,2]-tempb$V2)) })
  tempa$min_distance = min_distance
  tempa$b_pos = tempb$V2[min_distance_idx]
  out.dict[[length(out.dict)+1]] = tempa
}

out.table = do.call(rbind,out.dict)
# remove min_distance > 40000
out.table.f = out.table[which(out.table$min_distance>40000),]

write.table(out.table.f[,c("V1","V2","min_distance")], paste0(stage,"_specific_boundary.txt"),col.names=F,row.names=F,sep='\t')
}



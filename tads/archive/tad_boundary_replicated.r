setwd("../../analysis/tads/tad_calls")
for (stage in c("D00","D02","D05","D07","D15","D80")){

a=data.frame(fread(paste0(stage,"_Rep1.TAD.bed")))
b=data.frame(fread(paste0(stage,"_Rep2.TAD.bed")))

#out = a
#len = 0
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
out.table.f = out.table[which(out.table$min_distance<=40000),]
out.table.f$pos = (out.table.f$V2+out.table.f$b_pos)/2

write.table(out.table.f[,c("V1","pos")], paste0(stage,"_replicated.TAD.txt"),col.names=F,row.names=F,sep='\t')
}


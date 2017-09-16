args = commandArgs(trailing=T)
if (length(args) < 2) {
  print("arguments too short. %prog input output [start end]")
  quit()
  }

input = args[1]
output = args[2]
bin.file = args[3]
print(c(input,output,bin.file))
## load contact matrices
contacts=data.frame(fread(input))
contacts$dist = contacts$V2-contacts$V1
margin = aggregate(V3~dist,contacts,FUN=mean)
contacts$exp_global = margin$V3[match(contacts$dist,margin$dist)]
contacts$p_global = ppois(contacts$V3,contacts$exp_global,lower.tail=F)
contacts$exp_local = contacts$exp_global
## load the promoter bins.
bins = read.table(bin.file)$V2-1

# candidates
cand = contacts[which(contacts$p_global< 0.01 & ( contacts$V1 %in% bins | contacts$V2 %in% bins)),]
print(c("number of candiates", nrow(cand)))
library(doParallel)
registerDoParallel(cores=8)

out = foreach(i=1:nrow(cand)) %dopar% {
#print(i)
  tmp = contacts[which( contacts$V1 > cand[i,1]-40000 & contacts$V1 < cand[i,1]+40000 & 
                 contacts$V2 > cand[i,2]-40000 & contacts$V2 < cand[i,2]+40000 ),]
  tmp$corrected = tmp$V3/margin$V3[match(tmp$dist,margin$dist)]*margin$V3[which(margin$dist==cand[i,4])]
  cand$exp_local[i] = mean(tmp$corrected)
}
cand$exp_local = unlist(out)
cand$p_local = ppois(cand$V3,cand$exp_local,lower.tail=F)

write.table(cand,output,row.names=F,sep="\t",quote=F)



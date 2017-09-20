library(data.table)
args = commandArgs(trailing=T)
if (length(args) < 5) {
  print("arguments too short. %prog raw output start end balanced")
  quit()
  }

raw = args[1]
output = args[2]
balanced = args[3]
start = as.integer(args[4])
end = as.integer(args[5])
print(c(raw,output))

## read raw and balanced data. 
a=data.frame(fread(raw))
colnames(a) = c("x","y","raw")
a1 = data.frame(fread(balanced))
a$balanced = a1$V3
a$b2r_factor = a$raw/a$balanced
a$dist = a$y-a$x
b = aggregate(cbind(raw,balanced)~dist,a,FUN=mean)

a$exp_global_raw = b$raw[match(a$dist,b$dist)]
a$exp_global_balanced = b$balanced[match(a$dist,b$dist)]
a$exp_global_b2raw = a$exp_global_balanced * a$b2r_factor
a$p_global_raw = ppois(a$raw,a$exp_global_raw,lower.tail=F)
a$p_global_balanced = ppois(a$balanced, a$exp_global_balanced, lower.tail=F)
a$exp_local_balanced = a$exp_global_balanced
# candidates
cand = a[which(a$p_global_balanced< 0.01 & a$x >= start & a$y <= end),]


library(doParallel)
registerDoParallel(cores=8)

out = foreach(i=1:nrow(cand)) %dopar% {
print(i)
  tmp = a[which( a$x > cand[i,1]-40000 & a$x < cand[i,1]+40000 & 
                 a$y > cand[i,2]-40000 & a$y < cand[i,2]+40000 ),]
  tmp$corrected = tmp$balanced/b$balanced[match(tmp$dist,b$dist)]*b$balanced[which(b$dist==cand[i,"dist"])]
  cand$exp_local[i] = mean(tmp$corrected)
}
cand$exp_local_balanced = unlist(out)
cand$exp_local_b2raw = cand$exp_local_balanced * cand$b2r_factor
cand$p_local_balanced = ppois(cand$balanced,cand$exp_local_balanced,lower.tail=F)
cand$p_local_b2r = ppois(cand$raw,cand$exp_local_b2raw,lower.tail=F)
plot(-log10(cand$p_local_balanced), -log10(cand$p_local_b2r))

write.table(cand,output,row.names=F,sep="\t",quote=F)



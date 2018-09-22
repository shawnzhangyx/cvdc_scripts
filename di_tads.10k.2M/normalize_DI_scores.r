setwd("../../analysis/di_tads.10k.2M")

files=list.files(path="../../data/hic/DI",pattern="10000.200.DI.bedGraph$",full.names=T)

dat = list()
for (file in files){
  print(file)
  dat[[file]] = data.frame(fread(file))
  }
  

#do.call(function(x){merge(x,,by=c("V1","V2","V3"))},dat)
mat = Reduce(function(...)merge(...,by=c("V1","V2","V3")),dat)

colnames(mat)[4:15] = sub(".*\\/(.*).10000.200.DI.bedGraph","\\1",files)

eq0 = mat[,4:15]==0
num_Eq0 = rowSums(eq0)

mat2 = mat[which(num_Eq0<12),]

library(preprocessCore)
qtl = normalize.quantiles(as.matrix(mat2[,4:15]))

mat3 = cbind(mat2[,1:3],qtl)

mat3 = mat3[order(mat3$V1,mat3$V2),]

for (i in 1:12){
name = sub(".*\\/(.*).10000.200.DI.bedGraph","\\1",files)[i]
out = mat3[,c(1:3,i+3)]
write.table(out,paste0("DI_quantile/", name,".10000.200.DI.bedGraph"),row.names=F,col.names=F,quote=F,sep="\t")
}  


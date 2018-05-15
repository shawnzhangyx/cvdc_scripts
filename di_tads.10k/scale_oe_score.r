setwd("../../analysis/di_tads.10k/oe_median2")
files = list.files(pattern="overlap.txt")


#dat = list()
for (file in files){
  print(file)
  tmp = fread(file)
  md = aggregate(V8~V4,tmp,median)
  tmp$median = md$V8[match(tmp$V4,md$V4)]
  tmp$score = tmp$V8-tmp$median+1
  write.table(tmp[,c(1:7,11)],paste0(file,".scaled"),row.names=F,col.names=F,quote=F,sep='\t')
  }


setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/tads/insulation_data")

files = list.files(pattern="bedgraph")

for (i in 1:length(files)){
  file = files[i]
  data = data.frame(fread(file))
  data$name = paste(data$V1,data$V2,data$V3)
  data = data[,-c(1:3)]
  if (i ==1) {
  data_out = data
  } else {
  data_out = merge(data_out,data,by="name")
  }
  }

chrom = sub("(.*) .* .*","\\1",data_out$name)
start = sub(".* (.*) .*","\\1",data_out$name)
end = sub(".* .* (.*)","\\1",data_out$name)
out = data.frame(chrom,start,end,data_out[,-1])
colnames(out)[-c(1:3)] = substr(files,1,5)

write.table(out,"combined.matrix",quote=F,row.names=F,col.names=T,sep='\t')

setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/tads/directionality_data")
files = list.files(pattern="bedgraph")
for (i in 1:length(files)){
  file = files[i]
  data = data.frame(fread(file))
  data$name = paste(data$V1,data$V2,data$V3)
  data = data[,-c(1:3)]
  if (i ==1) {
  data_out = data
  } else {
  data_out = merge(data_out,data,by="name")
  }
  }

chrom = sub("(.*) .* .*","\\1",data_out$name)
start = sub(".* (.*) .*","\\1",data_out$name)
end = sub(".* .* (.*)","\\1",data_out$name)
out = data.frame(chrom,start,end,data_out[,-1])
colnames(out)[-c(1:3)] = substr(files,1,5)


write.table(out,"combined.matrix",quote=F,row.names=F,col.names=T,sep='\t')


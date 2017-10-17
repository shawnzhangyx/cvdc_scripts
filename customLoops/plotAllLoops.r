setwd("../../analysis/customLoops")
loops = list()
for (file in list.files(path="clusters",pattern="order.bed")){
  loops[[file]] = read.table(file) }


a1 = read.delim("loops/loops.nondynamic.cluster.anchor1.txt",stringsAsFactors=F)
a2 = read.delim("loops/loops.nondynamic.cluster.anchor2.txt",stringsAsFactors=F)


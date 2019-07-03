setwd("../../analysis/hiccup_loops")
dyn = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt",stringsAsFactors=F)
a = read.delim("anchors/anchors.uniq.30k.num_loops.txt",header=F,stringsAsFactors=F)
colnames(a)[1:3] = c("chr","start","end")
lists = list()
lists[["anchor"]] = a[,c(1:3)]
for (feature in c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","rnaseq","CTCF")){
  data = read.delim(paste0("overlap_anchors_to_features/anchor.",
    feature,".norm_counts.txt"))
#  data[,c(4:9)] = sweep(data[,c(4:9)],1,apply(data[,c(4:9)],1,max),'/')
  lists[[feature]] = data
    }
feature = read.delim("overlap_anchors_to_features/anchor.all_features.txt")
lists[["feature"]] = feature
m = Reduce(function(...)merge(..., by=c("chr","start","end"),sort=F),lists)
m$name = paste(m$chr, m$start)
dyn$chr = sub("(.*) (.*) (.*)","\\1",dyn$name) 
dyn$x1 = as.numeric(sub("(.*) (.*) (.*)","\\2",dyn$name))-10000
dyn$y1 = as.numeric(sub("(.*) (.*) (.*)","\\3",dyn$name))-10000
a1 = m[match(paste(dyn$chr,dyn$x1),m$name),]
a2 = m[match(paste(dyn$chr,dyn$y1),m$name),]

write.table(a1,"loops/loops.dynamic.cluster.anchor1.txt",row.names=F,quote=F,sep='\t')
write.table(a2,"loops/loops.dynamic.cluster.anchor2.txt",row.names=F,quote=F,sep='\t')

nondyn = read.delim("loops/loops.cpb.logFC.edger.nondynamic.txt",stringsAsFactors=F)
nondyn$chr = sub("(.*) (.*) (.*)","\\1",nondyn$name)
nondyn$x1 = as.numeric(sub("(.*) (.*) (.*)","\\2",nondyn$name))-10000
nondyn$y1 = as.numeric(sub("(.*) (.*) (.*)","\\3",nondyn$name))-10000
n1 = m[match(paste(nondyn$chr,nondyn$x1),m$name),]
n2 = m[match(paste(nondyn$chr,nondyn$y1),m$name),]

write.table(n1,"loops/loops.nondynamic.cluster.anchor1.txt",row.names=F,quote=F,sep='\t')
write.table(n2,"loops/loops.nondynamic.cluster.anchor2.txt",row.names=F,quote=F,sep='\t')


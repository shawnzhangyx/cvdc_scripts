setwd("../../analysis/hiccup_loops")

a = read.delim("replicated_loops/loop_anchors.uniq.30k.num_loops.txt",header=F)
l = read.delim("loops_merged_across_samples.uniq.replicated.tab")
d = read.delim("replicated_loops/loops.cpb.logFC.edger.dynamic.cluster.txt")
#g = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)

#g2 = aggregate(V7~V1+V2,g,paste,collapse=",")
#g2$name = paste(g2$V1,g2$V2+10000)
## add the information for the dynamic loops to anchor. 
#l$a1 = paste(l$chr1,l$x1)
#l$a2 = paste(l$chr1,l$y1)

d$a1 = paste(d$chr,d$x1)
d$a2 = paste(d$chr,d$y1)
a$name = paste(a$V1,a$V2+10000)

cluster=""
for (i in 1:nrow(a)){
  tmp = d[which(d$a1 == a[i,5] | d$a2 == a[i,5]),]
  cluster[i] = paste(sort(tmp$cluster), collapse=",")
  }

a$cluster = cluster
require(stringr)
a$dynamic_count = str_count(a$cluster,'[0-9]')

D00 = str_count(a$cluster,'[56]')
D02 = str_count(a$cluster,'[4]')
D15 = str_count(a$cluster,'[12]')
D80 = str_count(a$cluster,'[3]')
a$cluster_dense = paste( ifelse(D00>0, "D00", ""),
        ifelse(D02>0, "D02", ""),
        ifelse(D15>0, "D15", ""),
        ifelse(D80>0, "D80", ""),
    sep=",")

#plot(table(a$cluster_dense),type='h')

write.table(a,"replicated_loops/loop_anchors.uniq.30k.num_loops.cluster.txt",row.names=F,sep='\t',quote=F)


setwd("../../analysis/hiccup_loops/")

all = read.delim("overlap_anchors_to_features/anchor.all_features.txt")
apply(all[,-c(1:3)]>0,2,table)
#       CTCF  ATAC H3K4me1 H3K4me3 H3K27me3 H3K27ac   TSS
#FALSE  1245  2346     821    9018     9074    5881  5457
#TRUE  15303 14202   15727    7530     7474   10667 11091
degree = read.delim("loop_anchors.uniq.30k.num_loops.txt",header=F)
colnames(degree) = c("chr","start","end","degree")
merged = merge(all,degree,by=c("chr","start","end"))
merged = merged[order(-merged$degree),]

## plot the percent of anchors contain CTCF. 
ggplot(merged, aes(x=degree,fill=CTCF>0)) + 
  geom_bar(position="fill",stat="count") 

ggplot(merged, aes(x=degree,fill=TSS>0)) +
  geom_bar(position="fill",stat="count")

ggplot(merged, aes(x=degree,fill=H3K27ac>0)) +
  geom_bar(position="fill",stat="count")

ggplot(merged, aes(x=degree,fill=H3K27me3>0)) +
  geom_bar(position="fill",stat="count")

ggplot(merged, aes(x=degree,fill=H3K4me1>0)) +
  geom_bar(position="fill",stat="count")

ggplot(merged, aes(x=degree,fill=H3K4me3>0)) +
  geom_bar(position="fill",stat="count")



ggplot(merged, aes(x=factor(degree),y=CTCF)) +
  geom_boxplot()

ggplot(merged, aes(x=factor(degree),y=H3K27me3)) +
  geom_boxplot()



table(all$H3K27me3>0,all$H3K27ac>0)
#      FALSE TRUE
#FALSE  2800 7210
#TRUE   2420 9555

table(all$TSS>0,all$H3K27ac>0)


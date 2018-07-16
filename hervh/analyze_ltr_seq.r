d = read.delim("hervh.sorted_rnaseq.strand.bed",header=F)
CHR=["chr20"]
d$rank = 1:nrow(d)
d$name = paste0("HERVH",1:nrow(d))

a=read.delim("multi_seq_aln/5p_LTRs.txt",header=F)
b=read.delim("multi_seq_aln/3p_LTRs.txt",header=F)

a = a[!duplicated(a[,c(4,10)]),]
b = b[!duplicated(b[,c(4,10)]),]

a$rank = d$rank[match(a$V4,d$V4)]
a$tier = ceiling(a$rank/50)
b$rank = d$rank[match(b$V4,d$V4)]
b$tier = ceiling(b$rank/50)

a$name = paste0(d$name[match(a$V4,d$V4)],".5P")
b$name = paste0(d$name[match(b$V4,d$V4)],".3P")


g1 = ggplot(a) + geom_bar(aes(factor(tier),fill= V10),stat="count") +
  ggtitle("5'LTR") + theme_bw()
g2 = ggplot(b) + geom_bar(aes(factor(tier),fill= V10),stat="count") + 
  ggtitle("3'LTR") + theme_bw()

library(gridExtra)
#grid.arrange(g1,g2)

comb = rbind(a,b)

#dup.name = comb$V4[which(duplicated(comb[,c(4,10)]))]
#dup = comb[which(comb$V4 %in% dup.name),]
dup1 = comb[duplicated(comb[,c(4,10)]),]
dup2 = comb[duplicated(comb[,c(4,10)],fromLast=T),]
dup = rbind(dup2,dup1)

g3 = ggplot(dup) + geom_bar(aes(factor(tier),fill= V10),stat="count")+ 
  ggtitle("Paired") + theme_bw()

g4 = ggplot(subset(dup,rank<500)) + geom_point(aes(x=rank,y=V9-V8,color=V10)) +
  ggtitle("LTR length") + theme_bw()
g5 = ggplot(subset(dup1,rank<500)) + geom_point(aes(x=rank,y=V3-V2)) + 
  ggtitle("HERVH-int length") + theme_bw()

pdf("figures/LTR_pair_types.pdf")
grid.arrange(g1,g2,g3)
grid.arrange(g4,g5)
dev.off()

table(dup$tier,dup$V9-dup$V8>420 & dup$V10=="LTR7")


for (name in dup1$V4) {
  seq = dup[which(dup$V4 == name),]
  write.table(seq[,c(7,8,9,14)],paste0("multi_seq_aln/pairs/",seq$name[1],".bed"),row.names=F,col.names=F,sep='\t',quote=F)
  }




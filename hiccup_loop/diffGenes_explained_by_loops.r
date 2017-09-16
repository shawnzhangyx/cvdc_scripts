setwd("../../analysis/hiccup_loops/")

gene = read.delim("../../data/rnaseq/gene.rpkm.cluster.txt")
overlap = read.delim("overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)

gene$InLoop = gene$Geneid %in% overlap$V7

table(gene$cluster,gene$InLoop)
#    FALSE TRUE
#  1   494  620
#  2    89  203
#  3  1570 1852
#  4   187  359
#  5  1042 1413
#  6   320  635

d = read.delim("loops/loops.cpb.logFC.edger.dynamic.cluster.txt")

chr =sub("(.*) (.*) (.*)","\\1",d$name)
start =sub("(.*) (.*) (.*)","\\2",d$name)
end =sub("(.*) (.*) (.*)","\\3",d$name)
d$a1 = paste(chr,start)
d$a2 = paste(chr,end)

overlap$name = paste(overlap$V1,overlap$V2+10000)
overlap$c1 = d$cluster[match(overlap$name,d$a1)]
overlap$c2 = d$cluster[match(overlap$name,d$a2)]

gene$C1 = gene$Geneid %in% overlap$V7[which(overlap$c1==1 | overlap$c2==1)]
gene$C2 = gene$Geneid %in% overlap$V7[which(overlap$c1==2 | overlap$c2==2)]
gene$C3 = gene$Geneid %in% overlap$V7[which(overlap$c1==3 | overlap$c2==3)]
gene$C4 = gene$Geneid %in% overlap$V7[which(overlap$c1==4 | overlap$c2==4)]
gene$C5 = gene$Geneid %in% overlap$V7[which(overlap$c1==5 | overlap$c2==5)]
gene$C6 = gene$Geneid %in% overlap$V7[which(overlap$c1==6 | overlap$c2==6)]
gene$Total = 1

out = aggregate(cbind(Total,InLoop,C1,C2,C3,C4,C5,C6)~cluster,data=gene,FUN=sum)

out$Nondynamic = out$InLoop-rowSums(out[,4:9])
#  cluster Total InLoop C1  C2 C3  C4 C5  C6 Nondynamic
#1       1  1114    620 16  79 19  52 35  42        377
#2       2   292    203 12  18 47  29 14  17         66
#3       3  3422   1852 16 104 29 127 46 112       1418
#4       4   546    359 10  25 12  61 25  33        193
#5       5  2455   1413  7  72 16 101 47  79       1091
#6       6   955    635  3  29 13  41 25  78        446


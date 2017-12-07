setwd("../../analysis/customLoops")

loop=read.delim("loops/loops.cpb.logFC.edger.final.cluster.txt")
loop$a1 = sub("(.*) (.*) (.*)","\\1 \\2",loop$name)
loop$a2 = sub("(.*) (.*) (.*)","\\1 \\3",loop$name)

H3K4me3 = read.table("overlap_anchors_to_features/anchor.H3K4me3_merged_peaks.txt")
prom = aggregate(V7~V1+V2+V3,H3K4me3,FUN=function(vec){length(which(vec!="."))})
colnames(prom) = c("V1","V2","V3","H3K4me3")
a1 = prom[match(loop$a1,paste(prom$V1,prom$V2+10000)),]
a2 = prom[match(loop$a2,paste(prom$V1,prom$V2+10000)),]

H3K4me1 = read.table("overlap_anchors_to_features/anchor.H3K4me1_merged_peaks.txt")
enh = aggregate(V7~V1+V2+V3,H3K4me1,FUN=function(vec){length(which(vec!="."))})
a1$H3K4me1 = enh$V7[match(loop$a1, paste(enh$V1,enh$V2+10000))]
a2$H3K4me1 = enh$V7[match(loop$a2, paste(enh$V1,enh$V2+10000))]

H3K27ac = read.table("overlap_anchors_to_features/anchor.H3K27ac_merged_peaks.txt")
act = aggregate(V7~V1+V2+V3,H3K27ac,FUN=function(vec){length(which(vec!="."))})
a1$H3K27ac = act$V7[match(loop$a1, paste(act$V1,act$V2+10000))]
a2$H3K27ac = act$V7[match(loop$a2, paste(act$V1,act$V2+10000))]


a1$PE = "U"
a1$PE[which(a1$H3K4me3>0)] = "P"
a1$PE[which(a1$H3K4me3==0 & a1$H3K4me1>0)] = "E"
a2$PE = "U"
a2$PE[which(a2$H3K4me3>0)] = "P"
a2$PE[which(a2$H3K4me3==0 & a2$H3K4me1>0)] = "E"

type = sapply(1:nrow(loop), function(i){ paste( sort(c(a1$PE[i],a2$PE[i])),collapse="-")})

type.by.cluster = table(loop$cluster,type)
prop = sweep(type.by.cluster,1,rowSums(type.by.cluster),'/')[,c(1,2,4)]
all.prop = (table(type)/sum(table(type))) [c(1,2,4)]

all.melted = data.frame(all.prop)
melted = melt(prop)

pdf("figures/loop_type_PE.pdf",width=5,height=5)
ggplot(all.melted, aes(x=type,y=Freq)) + geom_bar(stat="identity",fill=cbbPalette[6],width=0.5,color='black') + 
  theme_bw() + ylab("Fraction")

ggplot(melted, aes(fill=factor(type),x=Var1,y=value)) +
  geom_bar(stat='identity',position='stack',color='black') +
  ylab("Fraction") +
  scale_fill_manual(values=cbbPalette[c(4,5,6)]) + ylim(0,1) +
#  scale_fill_brewer(palette="RdBu",name="Cluster") +
  theme_bw()

ggplot(melted, aes(fill=factor(Var1),x=type,y=value)) + 
  geom_bar(stat='identity',position='dodge',color='black') + 
  ylab("Fraction") + 
  scale_fill_brewer(palette="RdBu",name="Cluster") +
#  scale_fill_manual(values=cbbPalette[c(2,3,4)])
  theme_bw()
dev.off()

#a1$status="Unknown"
#a1$status[which(a1$H3K4me3>0 & a1$H3K27ac > 0)] = "Prom.Active" 
#a1$status[which(a1$H3K4me3>0 & a1$H3K27ac ==0)] = "Prom.Inactive"
#a1$status[which(a1$H3K4me3==0 & a1$H3K4me1 > 0 & a1$H3K27ac > 0)] = "Enh.Active"
#a1$status[which(a1$H3K4me3==0 & a1$H3K4me1 > 0 & a1$H3K27ac == 0)] = "Enh.Primed"


> table(a1$H3K4me3>0, a1$H3K27ac>0)

        FALSE TRUE
          FALSE  3264 3637
            TRUE   1021 6293


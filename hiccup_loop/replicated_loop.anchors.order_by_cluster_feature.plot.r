setwd("../../analysis/hiccup_loops")

a = read.delim("anchors/anchors.sorted.by.cluster_feature.txt")

lists = list()
lists[["anchor"]] = a[,c(1:3)]
for (feature in c("H3K4me3","H3K27me3","H3K27ac","H3K4me1","rnaseq")){
  data = read.delim(paste0("overlap_anchors_to_features/anchor.",
    feature,".norm_counts.txt"))
  data[,c(4:9)] = sweep(data[,c(4:9)],1,apply(data[,c(4:9)],1,max),'/')
  lists[[feature]] = data
    }

m = Reduce(function(...)merge(..., by=c("chr","start","end"),sort=F),lists)

num = table(a$cluster_dense)
inc =0
for (i in 1:length(num)) inc[i+1] =inc[i]+num[i]

mat = m[-c(1:3)]
rownames(mat) = 1:nrow(mat)
mat[is.na(mat)] = 0
melted = melt(as.matrix(mat))
pdf("test.pdf",height=50,width=10)
ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_y_continuous(breaks=inc[-1],labels = names(num))+
  scale_fill_gradient2(high="red",mid="white") +
  geom_hline(yintercept=inc,size=1) +
  geom_vline(xintercept=c(6,12,18,24)+0.5)+
  theme ( axis.text.x = element_text(angle=90))
dev.off()

name = paste(m$chr,m$start,m$end)
out = cbind(name,name,mat)
write.table(apply(out,2,rev), "anchors/anchors.sorted.by.cluster_feature.norm.cdt",row.names=F,
  sep="\t",quote=F)

#mat = m[which(m$chr=="chr14" & m$start==23860000),-c(1:3)]
#melted = melt(as.matrix(mat))
#ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
#  scale_y_continuous(breaks=inc[-1],labels = names(num))+
#  scale_fill_gradient2(high="red",mid="white") +
#  geom_vline(xintercept=c(6,12,18,24)+0.5)+
#  theme ( axis.text.x = element_text(angle=90))


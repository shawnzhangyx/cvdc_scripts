setwd("../../analysis/hiccup_loops/clusters/")

km = read.delim("cpb.dynamic.clusters.txt")
K = max(km$cluster)
num = table(km$cluster)
num.inc = sapply(1:length(num), function(i){ sum(num[1:i])})

a1 = data.frame(fread("dynamic.loop.anchor1.bed"))
a2 = data.frame(fread("dynamic.loop.anchor2.bed"))
a1$V5 = 1:nrow(a1)
a2$V5 = 1:nrow(a2)

feature = read.delim("../overlap_features/anchor.all_features.txt")

mark="H3K27ac"
pdf("dynamic.anchors.feature.cpm.pdf",width=20,height=40)
require(gridExtra)
for (mark in c("H3K27ac","H3K27me3","H3K4me1","H3K4me3","atac","rnaseq")){
  g.list = list()
  for (anchor in list(a1,a2)) {
rpm = data.frame(fread(paste0("../overlap_features/anchor.",mark,".rpm.txt")))
a1.out = merge(anchor,rpm,by.x=c("V1","V2","V3"),by.y = c("Chr","Start","End"),all.x=TRUE,sort=F)
a1.out = merge(a1.out,feature, by.x=c("V1","V2","V3"),by.y = c("chr","start","end"),all.x=TRUE)
a1.out = a1.out[order(a1.out$V5),]

mat1 = as.matrix(a1.out[,c(9:20)])
mat1.n = sweep(mat1, 1, apply(mat1,1,function(x){sqrt(sum(x**2))}),'/')
  if ( mark %in% colnames(a1.out) ) {
    mat1.n[which(a1.out[[mark]]==0),] = 0
    }
rownames(mat1.n) = 1:nrow(mat1.n)
#mat1.n[is.na(mat1.n)] = 0

melted1 = melt(mat1.n)
g.list[[length(g.list)+1]] = ggplot(melted1,aes(x=Var2,y=Var1,fill=value)) + geom_tile() +
  scale_fill_gradient2(high="red",mid="white") +
  geom_abline(intercept=num.inc) +
  annotate("text",x=rep(12.5,K),y=num.inc-100,label=1:K) +
  theme(
     axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5),
     axis.text.y = element_blank()
     )
}
grid.arrange(grobs=g.list,ncol=2)
}
dev.off()


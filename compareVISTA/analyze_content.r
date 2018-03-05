a=read.delim("anchor.vista.overlaps.txt",header=F)
# a = read.delim("anchor.vista_hs.overlaps.txt",header=F)
a$anchor = paste(a$V1,a$V2+10000)
a2=read.delim("random30k.vista.ovleraps.txt",header=F)
b=read.delim("~/annotations/vista_database/VISTA_02_20_2018.enhancer.tissue.tsv")
l = read.delim("../customLoops/loops/loops.cpb.logFC.edger.final.cluster.txt")
l$a1 = sub("(.*) (.*) (.*)","\\1 \\2",l$name)
l$a2 = sub("(.*) (.*) (.*)","\\1 \\3",l$name)

prob = colSums(b[,-1])/103199
# prob = colSums(b[grep("hs", b$name),-1])/103199
tissues = names(sort(-prob)[1:8])

pval = list()
cluster = 0
for ( cluster in 0:5) {
print(cluster)
tmp = l[which(l$cluster==cluster),]
anchors = c(tmp$a1,tmp$a2)
elements = a$V7[which(a$anchor %in% anchors)]
d = b[which(b$name %in% elements),]
counts = colSums(d[,-1])

pval[[cluster+1]] = sapply(1:length(counts), function(i){ binom.test(x=counts[i],n=length(anchors),p=prob[i])$p.value})
}

dat = do.call(rbind, pval)
dat = dat[,which(colnames(dat) %in% tissues)]

options(scipen=2)

melted = melt(dat)
pdf("enrichment_of_vista_enhancer_at_loop_anchors.pdf")

ggplot(melted) + geom_tile(aes(x=-Var2,y=Var1,fill=-log10(value))) + 
  scale_fill_gradientn(values=c(0,0.5,1),colors=c("white","red")) + 
  theme( 
  axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()


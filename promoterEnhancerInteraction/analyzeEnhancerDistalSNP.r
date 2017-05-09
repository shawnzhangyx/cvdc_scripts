s)etwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/enhancer_promoter_interaction/enhancer2DistalValuesAndCorrelation")
#loop.gene.atac.dcast = dcast(loop.gene.atac2, V2+ V3 ~ variable, sum)

loop.gene.atac = read.delim("loop.gene.atac.txt")
loop = read.delim("loops.mat.txt",header=F)
rna = read.delim("rnaseq.txt")
atac = read.delim("atac.txt")

loop1.chr = sub("(.*) (.*) (.*)","\\1",loop.gene.atac$V1)
loop1.x1 = sub("(.*) (.*) (.*)","\\2",loop.gene.atac$V1)
loop1.y1 = sub("(.*) (.*) (.*)","\\3",loop.gene.atac$V1)

loop1 = paste(loop1.chr, 
              ifelse(loop1.x1 < loop1.y1, loop1.x1, loop1.y1),
              ifelse(loop1.x1 < loop1.y1, loop1.y1, loop1.x1))

loop2 = paste0("chr", loop$V1," ", loop$V2," ", loop$V3)

loop.gene.atac2 = cbind( loop.gene.atac[,-1],loop[match(loop1, loop2), -c(1:3)])
loop.gene.atac.agg = aggregate(.~V2 + V3, loop.gene.atac2, sum)

rna.m = rna[match(loop.gene.atac.agg$V2, rna$Annotation.Divergence),]
atac.m = atac[match(loop.gene.atac.agg$V3, atac$Geneid),]


cor.dist = as.dist(1-cor(t(rna.m[,-1])))
hc = hclust(cor.dist)

rna.o = rna.m[hc$order,]
colnames(rna.o)[-1] = sub("(D..?_.).*","\\1",colnames(rna.o)[-1])
rna.o[,-1] = sweep(rna.o[,-1],1, sqrt(apply(rna.o[,-1],1,function(vec){ sum(vec**2)})),'/')
rna.o$Annotation.Divergence = factor(rna.o$Annotation.Divergence, levels=unique(rna.o$Annotation.Divergence))
rna.melt = melt(rna.o)

atac.o = atac.m[hc$order,-c(2:6)]
colnames(atac.o)[-1] = sub("(D.._.).*","\\1",colnames(atac.o)[-1])
atac.o[,-1] = sweep(atac.o[,-1],1, sqrt(apply(atac.o[,-1],1,function(vec){ sum(vec**2)})),'/')
atac.o$Geneid = factor(atac.o$Geneid, levels=unique(atac.o$Geneid))
atac.melt = melt(atac.o)

loop.o = loop.gene.atac.agg[hc$order,]
loop.o$V2 = paste(loop.o$V2, loop.o$V3)
loop.o$V3 = NULL
colnames(loop.o)[-1] = paste0("D", rep(c("00","02","05","07","15","80"),each=2), rep(c("_1","_2"),6)) 

#loop.o[,-1] = sweep(loop.o[,-1],1, sqrt(apply(loop.o[,-1],1,function(vec){ sum(vec**2)})),'/')
loop.o$V2 = factor(loop.o$V2, levels=unique(loop.o$V2))
loop.melt = melt(loop.o)


ggplot(rna.melt, aes(x=variable,y=Annotation.Divergence,fill=value)) + geom_tile() + 
  scale_fill_gradient2(low='blue',high='red',mid='white',midpoint=0.3)

ggplot(atac.melt, aes(x=variable,y=Geneid, fill=value)) + geom_tile() +
  scale_fill_gradient2(low='blue',high='red',mid='white',midpoint=0.3)

ggplot(loop.melt, aes(x=variable,y=V2, fill=value)) + geom_tile() +
  scale_fill_gradient2(low='blue',high='red',mid='white',midpoint=0.3)




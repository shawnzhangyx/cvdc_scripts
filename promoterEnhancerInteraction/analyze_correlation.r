setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/enhancer_promoter_interaction")
#link= data.frame(fread("loop.inter.enhancerDistal.tss.txt"))
gene.link = data.frame(fread("tss.loop.overlap.txt"))
enhancer.link = data.frame(fread("enhancerDistal.loop.overlap.txt"))

gene.link$loop.name = paste(gene.link$V7,gene.link$V8,gene.link$V11)
gene.link2 = gene.link[,c(4,14)]
gene.link3 = gene.link2[!duplicated(gene.link2),]

enhancer.link$loop.name = paste(enhancer.link$V5,enhancer.link$V9, enhancer.link$V6)
enhancer.link2 = enhancer.link[,c(4,12)]
#enhancer.link3 = enhancer.link2[!duplicated(enhancer.link2),]

gene2enhancer = merge(gene.link3,enhancer.link2, by="loop.name",all=FALSE)

length(unique(gene2enhancer$V4.x)) #52383
length(unique(gene2enhancer$V4.y)) #62788
write.table(gene2enhancer,"enhancer2gene.pair.txt",row.names=F,col.names=F,sep='\t',quote=F)


### import the data from this on. 
gene2enhancer = data.frame(fread("enhancer2gene.pair.txt",header=F))
rnaseq = data.frame(fread("../../data/rnaseq/gene.rpkm.txt"))
rnaseq2 = rnaseq[,c(1,seq(2,13,2))]
rnaseq2[,-1] = (rnaseq2[,-1] + rnaseq[,seq(3,13,2)])/2
atac = data.frame(fread("../../data/atac/counts/atac.fpkm"))
atac2 = atac[,c(1,seq(7,18,2))]
atac2[,-1] = (atac2[,-1] + atac[,seq(8,18,2)])/2
gene2enhancer2 = gene2enhancer[gene2enhancer$V2 %in% rnaseq$Annotation.Divergence,]
# matched gene & atac.
rnaseq.m = rnaseq2[match(gene2enhancer2$V2,rnaseq2[,1]),-1]
atac.m = atac2[match(gene2enhancer2$V3,atac2[,1]),-1]
rnaseq.m = as.matrix(rnaseq.m)
atac.m = as.matrix(atac.m)

cor = sapply(1:nrow(rnaseq.m), function(i) cor.test(rnaseq.m[i,], atac.m[i,])$estimate)
#pval = sapply(1:nrow(rnaseq.m), function(i) cor.test(rnaseq.m[i,], atac.m[i,])$p.value)

gene2enhancer2$cor = cor
write.table(gene2enhancer2,"enhancer2gene.pair.cor.txt",row.names=F,col.names=F,sep='\t',quote=F)

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
gene.link = data.frame(fread("tss.loop.overlap.txt"))
enhancer.link = data.frame(fread("enhancerDistalSNP.loop.overlap.txt"))

gene.link$loop.name = paste(gene.link$V7,gene.link$V8,gene.link$V11)
gene.link2 = gene.link[,c(4,14)]
gene.link3 = gene.link2[!duplicated(gene.link2),]

enhancer.link$loop.name = paste(enhancer.link$V11,enhancer.link$V15, enhancer.link$V12)
enhancer.link2 = enhancer.link[,c(4,18)]
#enhancer.link3 = enhancer.link2[!duplicated(enhancer.link2),]

gene2enhancer = merge(gene.link3,enhancer.link2, by="loop.name",all=FALSE)
gene2enhancer = gene2enhancer[!duplicated(gene2enhancer),]

length(unique(gene2enhancer$V4.x)) #472
length(unique(gene2enhancer$V4.y)) #273
write.table(gene2enhancer,"enhancerDistalSNP2gene.pair.txt",row.names=F,col.names=F,sep='\t',quote=F)



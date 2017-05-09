setwd("/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/analysis/enhancer_promoter_interaction")

a=read.delim("enhancerDistalSNP2gene.pair.txt",header=F)
atac = data.frame(fread("../../data/atac/counts/atac.fpkm"))
rna = data.frame(fread("../../data/rnaseq/gene.rpkm.txt"))

genes = as.character(unique(a$V2)) #472
genes2 = NULL

require(limma)
for (i in 1:length(genes)){
  symbol = alias2Symbol(genes[i],species="Hs")
#  num[i] = length(symbol)
  if ( length(symbol) != 0 ) {
   # if ( symbol != genes[i]) 
      # { 
       genes2[i] = symbol}
      # } 
  }


length(which(genes %in% rna$Annotation.Divergence)) #279
length(which(genes %in% rna$Annotation.Divergence | genes2 %in% rna$Annotation.Divergence))
test  = !genes %in% rna$Annotation.Divergence & genes2 %in% rna$Annotation.Divergence
genes3 = ifelse(test, genes2, genes)
rna.m = rna[which(rna$Annotation.Divergence %in% genes3),]
rna.rmax = apply(rna.m[,-1],1,max)
rna.out = rna.m[which(rna.rmax>1),]
rna.out$Annotation.Divergence = genes[match(rna.out$Annotation.Divergence, genes3)]
system("mkdir enhancer2DistalValuesAndCorrelation")
write.table(rna.out,"enhancer2DistalValuesAndCorrelation/rnaseq.txt",row.names=F,sep='\t',quote=F)

peaks = as.character(unique(a$V3)) # 273
atac.m = atac[which(atac$Geneid %in% peaks),]
atac.rmax = apply(atac.m[,-c(1:6)],1,max)
write.table(atac.m,"enhancer2DistalValuesAndCorrelation/atac.txt",row.names=F,sep='\t',quote=F)

a.m = a[which(a$V2 %in% rna.out$Annotation.Divergence & a$V3 %in% atac.m$Geneid),]
loops = as.character(unique(a.m$V1))
loops = gsub(" ","\t",loops)
# loops = read.delim("loops.txt",header=F,stringsAsFactors=F)
#loops.ordered =t(apply(loops[,2:3],1,function(vec){sort(vec)}))
#loops = cbind(loops$V1, loops.ordered)
write.table(loops,"enhancer2DistalValuesAndCorrelation/loops.txt",row.names=F,sep='\t',col.names=F,quote=F)

write.table(a.m,"enhancer2DistalValuesAndCorrelation/loop.gene.atac.txt",row.names=F,sep='\t',quote=F)


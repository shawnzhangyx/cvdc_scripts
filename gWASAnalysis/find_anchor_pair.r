setwd("../../analysis/gWAS_customLoop/")
a=read.delim("anchors.overlap_ATAC_GWAS.bed",header=F)
a$name	=	paste(a$V1,a$V2)
au	=	data.frame(name=unique(a$name))
loop	=	read.delim("../customLoops/combined_loops.uniq.gt1.txt")
loop$a1	=	paste(loop$chr,loop$x-10000)
loop$a2	=	paste(loop$chr,loop$y-10000)

#au$left	=	loop$a1[match(au$name,loop$a2)]
au.left = merge(au,loop[,c("a1","a2")],by.x="name",by.y="a2")
au.right = merge(au,loop[,c("a1","a2")],by.x="name",by.y="a1")
colnames(au.left) = colnames(au.right) = c("A1","A2")
au.both = rbind(au.left,au.right)
#au$right	=	loop$a2[match(au$name,loop$a1)]
pairs	=	unique(au.both$A2)

genes=	read.delim("../customLoops/overlap_anchors_to_features/anchor.gene_tss.unique.txt",header=F)
agg	=	aggregate(V7~V1+V2,genes,function(vec){	paste(vec,collapse=",")})

pairs	=	data.frame(name=pairs,gene=agg$V7[match(pairs,	paste(agg$V1,agg$V2))])

#au$left.gene	=	pairs$gene[match(au$left,pairs$name)]
#au$right.gene	=	pairs$gene[match(au$right,pairs$name)]
au.both$gene = pairs$gene[match(au.both$A2,pairs$name)]
#au	=	au[	which(	rowSums(au[,c(4,5)]!=".",na.rm=T)	>0	),]
#out = merge(au,a, by="name")
#out = cbind(a[,-c(14:16)],au[match(a$name,au$name),])
out = cbind(a[match(au.both$A1,a$name),-c(14:16)],au.both)

#out$left = sub("chr.* (.*)","\\1",out$left)
#out$left[is.na(out$left)]=""
#out$right = sub("chr.* (.*)","\\1",out$right)
#out$right[is.na(out$right)]=""
out$A2 = sub("chr.* (.*)","\\1",out$A2)
out$A2[is.na(out$A2)]=""

write.table(out,	"anchors.overlap_genes.all.txt",row.names=F,sep='\t',quote=F)

##	select	candidates	by	hand.	
#	>	anchors.overlap_genes.candidates.txt

#cand = read.delim("anchors.overlap_genes.candidates.txt",header=F)



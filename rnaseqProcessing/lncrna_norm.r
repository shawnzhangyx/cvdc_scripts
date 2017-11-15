a=read.delim("output.counts",skip=1)

counts = a[,7:18]
rpm = sweep(counts,2,colSums(counts),'/') *1e6
rpkm = sweep(rpm,1,a$Length,'/') *1e3

out = data.frame(Geneid = a$Geneid,rpkm)
colnames(out)[-1] = sub("...bams.rnaseq_(D.._Rep.).bam","\\1",colnames(out)[-1])

write.table(out,"lncRNA.rpkm.txt",row.names=F,sep='\t',quote=F)

max = apply(out[,-1],1,max)
out2 = out[which(max>10),]
write.table(out2,"lncRNA.rpkm.gt10.txt",row.names=F,sep='\t',quote=F)


norm = out2[,-1]
norm = sweep(norm,1,apply(norm,1,max),'/')

cor = cor(t(norm))

hc = hclust(as.dist(1-cor))
norm.od = norm[hc$order,]
rownames(norm.od) =1:nrow(norm.od)
melted = melt(as.matrix(norm.od))
ggplot(melted, aes(x=Var2,y=Var1,fill=value)) + geom_tile()

require(edgeR)

group = sub("...bams.rnaseq_(D..)_Rep..bam","\\1",colnames(counts))
design = model.matrix(~0+group)
lvls = levels(factor(group))
colnames(design) = lvls
y= DGEList(counts=counts,group=group)
y =  calcNormFactors(y)
#write.table(cpm(y),paste0(type,".cpm.txt"),sep="\t",quote=F)
y<-estimateCommonDisp(y)
y<-estimateGLMTagwiseDisp(y,design)
fit_tag = glmFit(y,design)
lrt = glmLRT(fit_tag, contrast = c(1,rep(-1,5)/5))

fdr = p.adjust(lrt$table$PValue,method="bonferroni")
out3 = data.frame(Geneid=a[,1],lrt$table,fdr)

out.sig = out3[which(out3$fdr<0.05),]
out.sig.fc = out.sig[which(out.sig$logFC>0),]
write.table(out.sig.fc,"lncRNA.D00.high.edgeR.txt",row.names=F,sep='\t',quote=F)

b= data.frame(fread("../../annotation/FANTOM_CAT.lv3_robust.all_lncRNA.gtf"))
gene = b[which(b$V3 == "gene"),]

get_gene_id = function(obj){
temp = strsplit(obj,";")[[1]][1]
gene_id = strsplit(temp,"\"")[[1]][2]
gene_id
}
gene$Geneid = sapply(gene$V9,get_gene_id)

gene.out.sig.fc = cbind(gene[match(out.sig.fc$Geneid,gene$Geneid),c(1,4,5,7,10)],out.sig.fc)

write.table(gene.out.sig.fc,"lncRNA.D00.high.edgeR.bed",row.names=F,sep='\t',quote=F)



a=read.table("overlap_tad_to_features/D00.gene_tss.unique.txt")
b=read.delim("../../data/rnaseq/gene.rpkm.txt")

com = b[which(b$Annotation.Divergence %in% a$V7),]
norm = sweep(com[,-1],1,apply(com[,-1],1,max),'/')

heatmap.2(as.matrix(norm),Colv=FALSE,Rowv=FALSE,
dendrogram="none",cexRow=1,cexCol=1,notecol='black',margins=c(5,5),tracecol=F,
col=colorRampPalette(c("lightyellow","red"))
)

#### H3K27ac

a=read.table("overlap_tad_to_features/D00.H3K27ac_merged_peaks.txt")
peak = read.delim("../../data/chipseq/counts/H3K27ac.counts")


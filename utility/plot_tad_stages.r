#!/usr/bin/env Rscript

args = commandArgs(trailing=T)
chr = args[1]
start = as.integer(args[2])
end = as.integer(args[3])
outdir = args[4]
outpdf = paste0(outdir,"/",chr,"_",start,"_",end,".pdf")
RATIO=0.5
## test ##
dist = (end-start)*RATIO+20000
matrices = list.files(pattern=paste0("^",chr,"_10000.txt"),path="../../data/hic/matrix",recursive=T,full.names=T)
samples = sub(".*/(D.._HiC_Rep.)/.*","\\1",matrices)


mat.list = list()
for (file in matrices){
  mat.list[[length(mat.list)+1]] = data.frame(fread(file))

}
#mat = do.call(rbind,mat.list)

mat.slice.list= list()
for (i in 1:length(mat.list)){
mat = mat.list[[i]]

mat.out = mat[which(mat$V1>start-dist & mat$V1<end+dist & mat$V2>start-dist & mat$V2<end+dist),]
mat.out$sample = samples[i]
mat.out$V3 = mat.out$V3/sum(mat.out$V3)*1e6
mat.slice.list[[length(mat.slice.list)+1]] = mat.out
}
mat.slice = do.call(rbind, mat.slice.list)
max = quantile(mat.slice$V3,0.75)
#point = mat.slice[which(mat.slice$V1==start & mat.slice$V2 == end),]
#max = max(point$V3)*1.5

mat.slice$V3[mat.slice$V3>max]=max
complement = mat.slice[,c(2,1,3,4)][which(mat.slice$V1 != mat.slice$V2),]
colnames(complement) = colnames(mat.slice)
mat.slice = rbind(mat.slice,complement)
#pdf(outpdf,height=30,width=10)
ggplot(mat.slice,aes(x=V1,y=V2,fill=V3)) + geom_tile() + 
  facet_wrap(~sample,ncol=2) +
  scale_fill_gradientn(colours = c("white", "red"),
  values = scales::rescale(c(0, 1)))+
#  scale_fill_gradient2(mid="white",high="red") + 
  ylim(end+dist,start-dist)+ 
  theme(
    axis.text.x = element_text(angle=90,vjust=0.5) 
    )
#dev.off()

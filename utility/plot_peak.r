#!/usr/bin/env Rscript

args = commandArgs(trailing=T)
#input=args[1]
#matrices =args[2]
chr = args[1]
start = as.integer(args[2])
end = as.integer(args[3])
INT=50000
## test ##
setwd("../../analysis/hiccup_loops/")
#start= 61680000
#end=64860000

matrices = list.files(pattern=paste0("^",chr,"_10000.txt"),path="../../data/hic/matrix_raw",recursive=T,full.names=T)
samples = sub(".*/(D.._HiC_Rep.)/.*","\\1",matrices)


mat.list = list()
for (file in matrices){
  mat.list[[length(mat.list)+1]] = data.frame(fread(file))

}
#mat = do.call(rbind,mat.list)

mat.slice.list= list()
for (i in 1:length(mat.list)){
#i=1
mat = mat.list[[i]]
mat.out = mat[which(mat$V1>start-INT & mat$V1<start+INT & mat$V2>end-INT & mat$V2<end+INT),]
mat.out$sample = samples[i]
mat.slice.list[[length(mat.slice.list)+1]] = mat.out
}
mat.slice = do.call(rbind, mat.slice.list)

pdf(paste0("figures/loop_heatmap/",chr,"_",start,"_",end,".pdf"))
ggplot(mat.slice,aes(x=V1,y=V2,fill=V3)) + geom_tile() + 
  facet_wrap(~sample) +
  scale_fill_gradient2(mid="white",high="red") + 
  theme(
    axis.text.x = element_text(angle=90,vjust=0.5) 
    )
dev.off()

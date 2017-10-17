setwd("../../data/chipseq/")

mark = "H3K27ac"
a=data.frame(fread(paste0("counts/",mark,".rpkm")))
b = data.frame(fread(paste0("merged_peaks/",mark,"_merged_peaks.overlap_stage.txt")))



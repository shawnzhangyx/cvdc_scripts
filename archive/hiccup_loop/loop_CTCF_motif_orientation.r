setwd("../../analysis/hiccup_loops")

a2ctcf = read.delim("overlap_anchors_to_features/anchor.CTCF_merged_peaks.txt",header=F)
loop = read.delim("combined_loops.uniq.txt")
ctcf = read.delim("../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.motif_orientation.unique.txt",header=F)
loop$a1 = paste(loop$chr1,loop$x1)
loop$a2 = paste(loop$chr2,loop$y1) 

a2ctcf$strand = ctcf$V6[match(a2ctcf$V7,ctcf$V4)]
a2ctcf$name = paste(a2ctcf$V1,a2ctcf$V2+10000)
a2agg = aggregate(strand~name, data=a2ctcf, function(vec){ paste(sort(vec),collapse=";")})

a2agg$ctcfCLEAN = ifelse(grepl("-",a2agg$strand),
    ifelse(grepl("\\+",a2agg$strand),"both", "-"),
    ifelse(grepl("\\+",a2agg$strand),"+","None"))

a2agg$anchor = ifelse(a2agg$name %in% loop$a1, 
  ifelse(a2agg$name %in% loop$a2, "Both","A1"),
  ifelse(a2agg$name %in% loop$a2, "A2","None"))




loop$a1ctcf = a2agg$ctcfCLEAN[match(loop$a1,a2agg$name)]
loop$a2ctcf = a2agg$ctcfCLEAN[match(loop$a2,a2agg$name)]

#loop$a1ctcfCLEAN = ifelse(grepl("-",loop$a1ctcf), 
#    ifelse(grepl("\\+",loop$a1ctcf),"both", "-"),
#    ifelse(grepl("\\+",loop$a1ctcf),"+","None"))
#loop$a2ctcfCLEAN = ifelse(grepl("-",loop$a2ctcf),
#    ifelse(grepl("\\+",loop$a2ctcf),"both", "-"),
#    ifelse(grepl("\\+",loop$a2ctcf),"+","None"))


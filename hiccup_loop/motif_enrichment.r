setwd("../../analysis/hiccup_loops/clusters/atac")

beds = list.files(pattern="bed")
# temperary
#beds = beds[-1]
total = sapply(1:length(beds),function(x){ nrow(read.delim(beds[x],header=F))})
bed.total = data.frame(beds,total)


files = list.files(pattern="motif_peak_count.txt")
# temporary
#files = files[-1]

data.list = list()
for (file in files){
  data = read.delim(file,header=F)
  data$cluster = sub("(.*).motif_peak_count.txt","\\1",file)
  data.list[[length(data.list)+1]] = data
  }

tab = do.call(rbind,data.list)
colnames(tab) = c("Motif","in_motifs","cluster")
# calculate the expected motif counts for all clusters.
tab.all = aggregate(in_motifs~Motif,data=tab,sum)
#tab.all$bg = tab.all$V2/sum(total)

tab$in_peaks = bed.total$total[match(tab$cluster, sub("(.*).bed","\\1",bed.total$beds))]
tab$out_peaks = sum(total) - tab$in_peaks
tab$out_motifs = tab.all$in_motifs[match(tab$Motif, tab.all$Motif)] - tab$in_motifs

or = pvalue = NULL
for (i in 1:nrow(tab)){
  print(i)
  tmp = tab[i,]
  test = fisher.test( matrix(c(tmp$in_motifs, tmp$in_peaks-tmp$in_motifs, 
    tmp$out_motifs, tmp$out_peaks-tmp$out_motifs),nrow=2))
  or[i] = test$estimate
  pvalue[i] = test$p.value
  }

tab$odds.ratio = or
tab$pvalue = pvalue

tab = tab[order(tab$pvalue),]
tab = tab[order(-tab$odds.ratio),]


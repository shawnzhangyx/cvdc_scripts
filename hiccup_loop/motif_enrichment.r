setwd("../../analysis/hiccup_loops/clusters/sep_by_cluster/")

beds = list.files(pattern="cluster...bed")
# temperary
beds = beds[-1]
total = sapply(1:length(beds),function(x){ nrow(read.delim(beds[x],header=F))})
bed.total = data.frame(beds,total)


files = list.files(pattern="motif_peak_count.txt")
# temporary
files = files[-1]

data.list = list()
for (file in files){
  data = read.delim(file,header=F)
  data$cluster = sub("(cluster..).*","\\1",file)
  data.list[[length(data.list)+1]] = data
  }

tab = do.call(rbind,data.list)
# calculate the expected motif counts for all clusters.
tab.all = aggregate(V2~V1,data=tab,sum)
tab.all$bg = tab.all$V2/sum(total)

tab$num_peaks = bed.total$total[match(tab$cluster, sub("(cluster..).bed","\\1",bed.total$beds))]

tab$motif_avg = tab$V2/tab$num_peaks
tab$motif_bg = tab.all$bg[match(tab$V1,tab.all$V1)]
tab$motif_FC = tab$motif_avg/tab$motif_bg

tab = tab[order(-tab$motif_FC),]

#head(tab[order(-tab$motif_FC),])


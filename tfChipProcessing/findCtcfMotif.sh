pushd ../../data/tfChIPseq/merged_peaks

fastaFromBed -fi /mnt/silencer2/home/yanxiazh/annotations/hg19/hg19.fa -bed CTCF_merged_peaks.bed > CTCF_merged_peaks.fa

fimo --max-strand --text ../../annotation/CTCF.motif  CTCF_merged_peaks.fa > CTCF_merged_peaks.motif_matches.txt

awk '{a[$5]++}END {for (i in a){print i,a[i]}}' CTCF_merged_peaks.motif_matches.txt

#!/usr/bin/env Rscript 
a = data.frame(fread("CTCF_merged_peaks.motif_matches.txt"))
p = data.frame(fread("CTCF_merged_peaks.bed"))
p$name =paste0(p$V1,":",p$V2,"-",p$V3)
agg = aggregate(strand~sequence.name,data=a, function(vec){ paste0(unique(sort(vec)),collapse=",") })
p$strand = agg$strand[match(p$name,agg$sequence.name)]
p$strand[is.na(p$strand)] = "Unknown"
write.table(p,"CTCF_merged_peaks.motif_orientation.relaxed.txt",row.names=F,col.names=F,sep="\t",quote=F)

a.sorted = a[order(a$p.value),]
a.dedup = a.sorted[!duplicated(a.sorted$sequence.name),]
p$strand = a.dedup$strand[match(p$name,a.dedup$sequence.name)]
p$strand[is.na(p$strand)] = "Unknown"
write.table(p,"CTCF_merged_peaks.motif_orientation.unique.txt",row.names=F,col.names=F,sep="\t",quote=F)


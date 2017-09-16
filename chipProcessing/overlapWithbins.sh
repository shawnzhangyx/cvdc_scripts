pushd ../../data/hic/chipseq/
mkdir -p 10k_bins
#mkfifo tmp.bed
mark=H3K27ac
cut -f 2- counts/${mark}.counts|tail -n +3 > tmp.bed | \
intersectBed -a ../../data/annotation/hg19_10k_tiling_bin.bed -b tmp.bed \
  -wo > 10k_bins/${mark}.10kb.counts.raw.txt 
rm tmp.bed

#!/usr/bin/env Rscript 
mark="H3K27ac"
a=read.table(paste0("10k_bins/",mark,".10kb.counts.raw.txt"))[,-c(4:8)]
a=a[,-ncol(a)]
agg = aggregate(.~V1+V2+V3,a,sum)
agg[,-c(1:3)] = sweep(agg[,-c(1:3)],2,colSums(agg[,-c(1:3)]),'/')*1e6

write.table(agg,paste0("10k_bins/",mark,".10kb.rpm.txt"),row.names=F,sep='\t',quote=F)

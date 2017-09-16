pushd ../../data/hic/tfChIPseq/
mkdir -p 10k_bins
#mkfifo tmp.bed
cut -f 2- counts/CTCF.counts|tail -n +3 > tmp.bed | \
intersectBed -a ../../data/annotation/hg19_10k_tiling_bin.bed -b tmp.bed \
  -wo > 10k_bins/CTCF.10kb.counts.raw.txt 
rm tmp.bed

#!/usr/bin/env Rscript 
a=read.table("10k_bins/CTCF.10kb.counts.raw.txt")[,-c(4:8)]
a=a[,-ncol(a)]
agg = aggregate(.~V1+V2+V3,a,sum)
agg[,-c(1:3)] = sweep(agg[,-c(1:3)],2,colSums(agg[,-c(1:3)]),'/')*1e6

write.table(agg,"10k_bins/CTCF.10kb.rpm.txt",row.names=F,sep='\t',quote=F)

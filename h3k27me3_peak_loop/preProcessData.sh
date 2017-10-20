pushd ../../analysis/h3k27me3_loop/

mkdir -p loops/

## only keep h3k27me3 peaks that are at least 3k wide.

awk '{ if ( $3-$2 >= 5000 ) print $0 }' ../../data/chipseq/merged_peaks/H3K27me3_merged_peaks.bed > H3K27me3_peaks.wide5k.bed
#get the rpkm of the peaks. 
join  -j 1 <(cut -f 4 H3K27me3_peaks.wide5k.bed|sort ) <(sort -k1,1 ../../data/chipseq/counts/H3K27me3.rpkm) > H3K27me3_peaks.wide5k.rpkm.txt
#clustering of the peak values. 

# record the H3K27me3 that overlap with loops
intersectBed -a ../customLoops/anchors/anchor1.bed -b H3K27me3_peaks.wide5k.bed -c > loops/anchor1.bed 
intersectBed -a ../customLoops/anchors/anchor2.bed -b H3K27me3_peaks.wide5k.bed -c > loops/anchor2.bed
intersectBed -a ../customLoops/anchors/anchor1.bed -b H3K27me3_peaks.wide5k.bed -u |intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -wo |cut -f 1-3,7 |uniq > loops/anchor1.gene.txt
intersectBed -a ../customLoops/anchors/anchor2.bed -b H3K27me3_peaks.wide5k.bed -u |intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -wo |cut -f 1-3,7 |uniq > loops/anchor2.gene.txt

# find out which loops has two. 
Rscript analyze_loops_connecting_h3k27me3.r


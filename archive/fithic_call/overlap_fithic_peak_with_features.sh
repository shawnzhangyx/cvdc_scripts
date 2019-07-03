cd  ../../analysis/fithic/
mkdir merged_peaks_overlap_features
outdir=merged_peaks_overlap_features
chipdir=../../data/chipseq/merged_peaks
intersectBed -a merged_peaks/rep_inter.all.txt -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |  
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c | 
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c | 
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c | 
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c \
  > $outdir/fithic.anchor1.features.txt

intersectBed -a merged_peaks/rep_inter.all.rev.txt -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c | 
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c | 
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c | 
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c | 
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c \
  > $outdir/fithic.anchor2.features.txt

intersectBed -a /mnt/silencer2/home/yanxiazh/annotations/hg19/hg19_10k_tiling_bin.bed -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c \
  > $outdir/all_genomic_bins.features.txt


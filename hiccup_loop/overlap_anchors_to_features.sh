pushd  ../../analysis/hiccup_loops/
outdir=overlap_features
mkdir -p $outdir
## intersect with all merged features
chipdir=../../data/chipseq/merged_peaks
echo -e "chr\tstart\tend\tCTCF\tATAC\tH3K4me1\tH3K4me3\tH3K27me3\tH3K27ac" |tee \
$outdir/all_genomic_bins.features.txt $outdir/anchor.all_features.txt
#$outdir/loops.anchor1.all_features.txt $outdir/loops.anchor2.all_features.txt 

#intersectBed -a loops_anchor1.bed -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
#  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |  
#  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c | 
#  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c | 
#  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c | 
#  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c \
#  >> $outdir/loops.anchor1.all_features.txt

#intersectBed -a loops_anchor2.bed -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
#  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c | 
#  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c | 
#  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c | 
#  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c | 
#  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c \
#  >> $outdir/loops.anchor2.all_features.txt

intersectBed -a loop_anchors.uniq.bed -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c \
  >> $outdir/anchor.all_features.txt


intersectBed -a /mnt/silencer2/home/yanxiazh/annotations/hg19/hg19_10k_tiling_bin.bed -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c \
  >> $outdir/all_genomic_bins.features.txt

### intersect with individual stages. 
chippeak=../../data/chipseq/peaks/
mark=H3K27me3
for mark in H3K27me3 H3K27ac H3K4me1 H3K4me3; do
  echo -e "chr\tstart\tend\tD00\tD02\tD05\tD07\tD15\tD80" \
  > $outdir/anchor.${mark}.peaks.txt
  cmd="cat loop_anchors.uniq.bed "
  for file in $( ls $chippeak/${mark}*/pooled/trurep_peaks.filtered.narrowPeak); do
    cmd+="| intersectBed -a - -b $file -c "
    done
  cmd+=">> $outdir/anchor.${mark}.peaks.txt"
  bash -c "$cmd"
  done

echo -e "chr\tstart\tend\tD00\tD02\tD05\tD07\tD15\tD80" \
  > $outdir/anchor.atac.peaks.txt
  cmd="cat loop_anchors.uniq.bed "
  for file in $( ls ../../data/atac/peaks/D??.ATAC.truepeak.filtered.narrowPeak); do
    cmd+="| intersectBed -a - -b $file -c "
    done
  cmd+=">> $outdir/anchor.atac.peaks.txt"
  bash -c "$cmd"




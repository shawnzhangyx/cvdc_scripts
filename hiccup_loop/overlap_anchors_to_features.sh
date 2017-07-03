pushd  ../../analysis/hiccup_loops/
outdir=overlap_anchors_to_features
mkdir -p $outdir
## intersect with all merged features
chipdir=../../data/chipseq/merged_peaks
echo -e "chr\tstart\tend\tCTCF\tATAC\tH3K4me1\tH3K4me3\tH3K27me3\tH3K27ac\tTSS" |tee \
$outdir/all_genomic_bins.features.txt $outdir/anchor.all_features.txt


intersectBed -a loop_anchors.uniq.30k.bed -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -c \
  >> $outdir/anchor.all_features.txt


intersectBed -a /mnt/silencer2/home/yanxiazh/annotations/hg19/hg19_10k_tiling_bin.bed -b ../../data/annotation/ctcf/CTCF_optimal_peaks_H1ESC.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -c \
  >> $outdir/all_genomic_bins.features.txt

### overlap with individual marks.

intersectBed -b ../../data/atac/peaks/atac_merged_peaks.bed -a loop_anchors.uniq.30k.bed -loj > $outdir/anchor.atac_merged_peaks.txt
for mark in H3K4me1 H3K4me3 H3K27ac H3K27me3; do
intersectBed -b $chipdir/${mark}_merged_peaks.bed -a loop_anchors.uniq.30k.bed -loj > $outdir/anchor.${mark}_merged_peaks.txt
done
intersectBed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -a loop_anchors.uniq.30k.bed -loj > $outdir/anchor.gene_tss.txt
sort -k1,1 -k2,2n -k7,7 -u $outdir/anchor.gene_tss.txt > $outdir/anchor.gene_tss.unique.txt



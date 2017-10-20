pushd  ../../analysis/customLoops/
outdir=loop_control_distance_matched
mkdir -p $outdir
## intersect with all merged features
chipdir=../../data/chipseq/merged_peaks
echo -e "chr\tstart\tend\tCTCF\tATAC\tH3K4me1\tH3K4me3\tH3K27me3\tH3K27ac\tTSS" |tee \
$outdir/anchor.all_features.txt


intersectBed -a loop_control_distance_matched/anchors.bed -b ../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/atac/peaks/atac_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me1_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K4me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27me3_merged_peaks.bed -c |
  intersectBed -a - -b $chipdir/H3K27ac_merged_peaks.bed -c |
  intersectBed -a - -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -c \
  >> $outdir/anchor.all_features.txt

### overlap with individual marks.

intersectBed -b ../../data/atac/peaks/atac_merged_peaks.bed -a loop_control_distance_matched/anchors.bed -loj -f 0.5 -F 0.5 -e > $outdir/anchor.atac_merged_peaks.txt
intersectBed -b ../../data/tfChIPseq/merged_peaks/CTCF_merged_peaks.bed -a loop_control_distance_matched/anchors.bed -loj -f 0.5 -F 0.5 -e > $outdir/anchor.CTCF_merged_peaks.txt

for mark in H3K4me1 H3K4me3 H3K27ac H3K27me3; do
intersectBed -b $chipdir/${mark}_merged_peaks.bed -a loop_control_distance_matched/anchors.bed -loj -f 0.5 -F 0.5 -e > $outdir/anchor.${mark}_merged_peaks.txt
done
intersectBed -b ../../data/annotation/gencode.v19.annotation.transcripts.tss1k.bed -a loop_control_distance_matched/anchors.bed -loj  > $outdir/anchor.gene_tss.txt
sort -k1,1 -k2,2n -k7,7 -u $outdir/anchor.gene_tss.txt > $outdir/anchor.gene_tss.unique.txt


anchors=../../../analysis/hiccup_loops/loop_anchors.saf
outdir=../../../analysis/hiccup_loops/overlap_features
#atac-seq
pushd ../../data/atac/bams/
files=$(ls D??_?_sorted_nodup.30.bam)
featureCounts -a  $anchors -o $outdir/anchor.atac.txt $files -F SAF -T 6 
popd
pushd ../../data/chipseq/bams/
for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3; do
  files=$(ls ${mark}*.nodup.bam)
  featureCounts -a $anchors -o $outdir/anchor.${mark}.txt $files -F SAF -T 6 
done
popd

pushd ../../data/rnaseq/bams/
files=$(ls rnaseq_D??_Rep?.bam)
featureCounts -a  $anchors -o $outdir/anchor.rnaseq.txt $files -F SAF -T 6 
popd


pushd ../../analysis/atacCenteredSites/
files=$(ls ../../data/atac/bams/D??_sorted_nodup-chrM.30.bam)
featureCounts -a ../../data/atac/peaks/atac_merged_peaks.summit.2k.saf -o counts/ATAC.counts $files -F SAF -T 8 

for mark in H3K27ac H3K4me1 
  do
  files=$(ls ../../data/chipseq/bams/${mark}_D*merged.bam)
  featureCounts -a ../../data/atac/peaks/atac_merged_peaks.summit.2k.saf -o counts/${mark}.counts $files -F SAF -T 8
  done
wait; echo "feature counts done"


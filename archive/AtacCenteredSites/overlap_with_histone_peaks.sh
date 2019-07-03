pushd ../../analysis/atacCenteredSites

mark=H3K27me3
outdir=overlaped_histone
mkdir -p $outdir
chippeak=../../data/chipseq/peaks/

for mark in H3K27me3 H3K27ac H3K4me1 H3K4me3; do
  echo -e "chr\tstart\tend\tName\tSummit\tD00\tD02\tD05\tD07\tD15\tD80" \
  > $outdir/atac_summits.${mark}.stages.txt
  cmd="cat ../../data/atac/peaks/atac_merged_peaks.summit.2k.txt "
  for file in $( ls $chippeak/${mark}*/pooled/trurep_peaks.filtered.narrowPeak); do
    cmd+="| intersectBed -a - -b $file -c -f 0.5 -F 0.5 -e "
    done
  cmd+=">> $outdir/atac_summits.${mark}.stages.txt"
  bash -c "$cmd"
  done


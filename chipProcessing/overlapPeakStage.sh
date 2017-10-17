pushd ../../data/chipseq/
mark=H3K27ac
for mark in H3K27me3 H3K4me3 H3K4me1; do
intersectBed -a merged_peaks/${mark}_merged_peaks.bed \
                    -b peaks/${mark}_D00/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
  intersectBed -a - -b peaks/${mark}_D02/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
  intersectBed -a - -b peaks/${mark}_D05/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
  intersectBed -a - -b peaks/${mark}_D07/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
  intersectBed -a - -b peaks/${mark}_D15/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
  intersectBed -a - -b peaks/${mark}_D80/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e \
   > merged_peaks/${mark}_merged_peaks.overlap_stage.txt
done

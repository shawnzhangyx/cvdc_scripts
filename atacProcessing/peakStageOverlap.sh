pushd ../../data/atac/peaks/
#mkdir ctcfPeaks
intersectBed -a atac_merged_peaks.bed \
  -b D00.ATAC.truepeak.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b D02.ATAC.truepeak.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b D05.ATAC.truepeak.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b D07.ATAC.truepeak.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b D15.ATAC.truepeak.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b D80.ATAC.truepeak.filtered.narrowPeak -c -f 0.5 -F 0.5 -e \
 > atac_merged_peaks.overlap_stage.txt


pushd ../../data/tfChIPseq/
#mkdir ctcfPeaks
intersectBed -a merged_peaks/CTCF_merged_peaks.bed -b peaks/CTCF_D00/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b peaks/CTCF_D02/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b peaks/CTCF_D05/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b peaks/CTCF_D07/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b peaks/CTCF_D15/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e | \
 intersectBed -a - -b peaks/CTCF_D80/pooled/trurep_peaks.filtered.narrowPeak -c -f 0.5 -F 0.5 -e  \
> merged_peaks/CTCF_merged_peaks.overlap_stage.txt



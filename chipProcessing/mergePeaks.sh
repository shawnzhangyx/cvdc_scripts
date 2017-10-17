cd ../../data/chipseq/
for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3 H3K9me3
  do
  (
  peaks=$(ls peaks/${mark}_*/pooled/trurep_peaks.narrowPeak)
  cat $peaks | cut -f 1-3 |sort -k1,1 -k2,2n -|mergeBed -i stdin | awk -v OFS='\t' 'BEGIN{num=0}{num++; print $0, "peak"num}' - | Rscript ../../scripts/chipProcessing/keep_regular_chroms.r > merged_peaks/${mark}_merged_peaks.bed
) &
  done
wait 
echo done

#for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3
#  do
#  intersectBed -f 0.5 -F 0.5 -e -u -a merged_peaks/${mark}_merged_peaks.bed -b merged_peaks/Input_recur_peaks.bed > merged_peaks/${mark}_merged_peaks.filtered.bed
#  intersectBed -f 0.5 -F 0.5 -e -v -a merged_peaks/${mark}_merged_peaks.bed -b merged_peaks/Input_recur_peaks.bed > merged_peaks/${mark}_merged_peaks.kept.bed
#  done 

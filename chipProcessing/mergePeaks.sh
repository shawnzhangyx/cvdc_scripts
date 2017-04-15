cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/
for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3 
  do
  (
  peaks=$(ls peaks/${mark}_*/pooled/trurep_peaks.narrowPeak)
  cat $peaks | cut -f 1-3 |sort -k1,1 -k2,2n -|mergeBed -i stdin | awk -v OFS='\t' 'BEGIN{num=0}{num++; print $0, "peak"num}' - > merged_peaks/${mark}_merged_peaks.bed
  ) &
  done
wait 
echo done


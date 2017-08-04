cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/tfChIPseq/
#for mark in CTCF
#  do
#  (
mark=CTCF
  peaks=$(ls peaks/${mark}_*/merged/*_peaks.narrowPeak)
  cat $peaks | cut -f 1-3 |sort -k1,1 -k2,2n -|mergeBed -i stdin | awk -v OFS='\t' 'BEGIN{num=0}{num++; print $0, "peak"num}' - | Rscript ../../scripts/chipProcessing/keep_regular_chroms.r > merged_peaks/${mark}_merged_peaks.bed
#) &
#  done
#wait
#echo done



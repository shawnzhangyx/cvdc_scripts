cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq

for day in 00 02 05 07 15 80
  do
  (
  base_dir=peaks/Input_D${day}
  mkdir $base_dir $base_dir/rep1 $base_dir/rep2 $base_dir/pooled
  ct1=$(ls bams/Input_D${day}_1_*nodup.bam)
  ct2=$(ls bams/Input_D${day}_2_*nodup.bam)
  echo $ct1 $ct2
  macs2 callpeak -t $ct1 $ct2 -n pooled --outdir $base_dir/pooled --tempdir $base_dir/pooled --nomodel --extsize 180 &
  macs2 callpeak -t $ct1 -n rep1 --outdir $base_dir/rep1 --tempdir $base_dir/rep1 --nomodel --extsize 180 &
  macs2 callpeak -t $ct2 -n rep2 --outdir $base_dir/rep2 --tempdir $base_dir/rep2 --nomodel --extsize 180 &
  wait 
  echo $day macs2 peak calls done

  pooled_peak=$base_dir/pooled/pooled_peaks.narrowPeak
  rep1_peak=$base_dir/rep1/rep1_peaks.narrowPeak
  rep2_peak=$base_dir/rep2/rep2_peaks.narrowPeak
  trurep_peak=$base_dir/pooled/trurep_peaks.narrowPeak
  intersectBed -a $pooled_peak -b $rep1_peak -f 0.5 -F 0.5 -e -u | intersectBed -a stdin -b $rep2_peak -f 0.5 -F 0.5 -e -u > $trurep_peak
 
  ) &
  done

wait 
echo Input Peak Calls Done

d00=peaks/Input_D00/pooled/pooled_peaks.narrowPeak
d02=peaks/Input_D02/pooled/pooled_peaks.narrowPeak
d05=peaks/Input_D05/pooled/pooled_peaks.narrowPeak
d07=peaks/Input_D07/pooled/pooled_peaks.narrowPeak
d15=peaks/Input_D15/pooled/pooled_peaks.narrowPeak
d80=peaks/Input_D80/pooled/pooled_peaks.narrowPeak

alias ints="intersectBed -f 0.5 -F 0.5 -e -u"
ints -a $d00 -b $d02 |ints -a stdin -b $d05 | ints -a stdin -b $d07 | ints -a stdin -b $d15 | ints -a stdin -b $d80 > merged_peaks/Input_recur_peaks.bed

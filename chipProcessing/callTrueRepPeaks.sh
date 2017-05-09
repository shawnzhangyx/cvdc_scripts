cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq

#mark=H3K27ac
#day=00
## link files
for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3 
  do 
  for day in 00 02 05 07 15 80
    do 
    (
    r1=$(ls bams/${mark}_D${day}_1_*nodup.bam)
    r2=$(ls bams/${mark}_D${day}_2_*nodup.bam)
    ct=$(ls bams/Input_D${day}_*nodup.bam)
    
    base_dir=peaks/${mark}_D${day}
    mkdir $base_dir
    mkdir $base_dir/rep1 $base_dir/rep2 $base_dir/pooled
    
    ## call peaks for pooled samples and replicates
    macs2 callpeak -t $r1 -c $ct -n rep1 --outdir $base_dir/rep1 --tempdir $base_dir/rep1 --nomodel --extsize 180
    macs2 callpeak -t $r2 -c $ct -n rep2 --outdir $base_dir/rep2 --tempdir $base_dir/rep2 --nomodel --extsize 180
    macs2 callpeak -t $r1 $r2 -c $ct -n pooled --outdir $base_dir/pooled --tempdir $base_dir/pooled --nomodel --extsize 180

    
    pooled_peak=$base_dir/pooled/pooled_peaks.narrowPeak
    rep1_peak=$base_dir/rep1/rep1_peaks.narrowPeak
    rep2_peak=$base_dir/rep2/rep2_peaks.narrowPeak
    trurep_peak=$base_dir/pooled/trurep_peaks.narrowPeak
    trurep_filtered_peak=$base_dir/pooled/trurep_peaks.filtered.narrowPeak
    intersectBed -a $pooled_peak -b $rep1_peak -f 0.5 -F 0.5 -e -u | intersectBed -a stdin -b $rep2_peak -f 0.5 -F 0.5 -e -u > $trurep_peak
    intersectBed -a $trurep_peak -b $HOME/annotations/hg19/wgEncodeDacMapabilityConsensusExcludable.bed -v > $trurep_filtered_peak
    ) &
    done
  done

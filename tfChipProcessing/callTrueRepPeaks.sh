cd ../../data/tfChIPseq

#for mark in H3K9me3 #H3K27ac H3K27me3 H3K4me1 H3K4me3 
#  do 
mark=CTCF
day=05
#  for day in 00 02 07 15
    do 
    (
    r1=$(ls bam/${mark}_D${day}_Rep1.bam)
    r2=$(ls bam/${mark}_D${day}_Rep2.bam)
    ct=$(ls bam/Input_D${day}_merged.bam)
    
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
#    done

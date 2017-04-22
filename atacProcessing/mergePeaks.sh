cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/
peaks=$(ls peaks/*.filtered.narrowPeak)
cat $peaks | cut -f 1-3 |sort -k1,1 -k2,2n -|mergeBed -i stdin | awk -v OFS='\t' 'BEGIN{num=0}{num++; print $0, "peak"num}' - |Rscript ../../scripts/atacProcessing/keep_regular_chroms.r > peaks/atac_merged_peaks.bed


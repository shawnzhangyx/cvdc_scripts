cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/
peaks=$(ls peaks/*.narrowPeak)
cat $peaks | cut -f 1-3 |sort -k1,1 -k2,2n -|mergeBed -i stdin | awk -v OFS='\t' 'BEGIN{num=0}{num++; print $0, "peak"num}' - > peaks/atac_merged_peaks.bed


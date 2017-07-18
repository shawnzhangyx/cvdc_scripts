cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/
peaks=$(ls peaks/*.filtered.narrowPeak)
cat $peaks | cut -f 1-3 |sort -k1,1 -k2,2n -|mergeBed -i stdin | awk -v OFS='\t' 'BEGIN{num=0}{num++; print $0, "peak"num}' - |Rscript ../../scripts/atacProcessing/keep_regular_chroms.r > peaks/atac_merged_peaks.bed
intersectBed -a peaks/atac_merged_peaks.bed -b  <(cat $peaks | awk -v OFS="\t" '{if ($10==-1){ print $1,int(($2+$3)/2),int(($2+$3)/2) }  else {print $1,$2+$10,$2+$10} }' ) -loj > peaks/atac_merged_peaks.all_summits.txt



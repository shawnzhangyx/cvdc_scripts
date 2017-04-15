cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/
if [ ! -d counts ]; then mkdir counts; fi 
peak=peaks/atac_merged_peaks.bed
count=counts/atac_counts.txt
bedtools multicov -bed $peak -bams $(ls bams/*nodup.bam) > $count


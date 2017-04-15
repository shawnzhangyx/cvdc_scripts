cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/merged_peaks

for mark in H3K27ac H3K27me3 H3K4me3 H3K4me1
  do 
  bash  ~/software/github/seq-min-scripts/bed_to_saf.sh ${mark}_merged_peaks.bed ${mark}_peaks.saf &
  done
wait; echo "conversion to SAF done"

## count the reads
cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/
if [ ! -d counts ]; then mkdir counts; fi 
for mark in H3K27ac H3K27me3 H3K4me3 H3K4me1
  do 
  files=$(ls bams/${mark}_*nodup.bam)
  featureCounts -a merged_peaks/${mark}_peaks.saf -o counts/${mark}.counts $files -F SAF -T 8 
  done
wait; echo "feature counts done"


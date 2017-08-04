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


## count the H3K27me3 reads against the 10k tiling array. 
cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/
mark=H3K27me3
  files=$(ls bams/${mark}_*nodup.bam)
    featureCounts -a /mnt/silencer2/home/yanxiazh/annotations/hg19/hg19_10k_tiling_bin.saf -o counts/tiling10k.${mark}.counts $files -F SAF -T 8

## count the reads against the 2k tiling array.
cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/
if [ ! -d counts ]; then mkdir counts; fi
for mark in H3K27ac H3K27me3 H3K4me3 H3K4me1 
  do
  files=$(ls bams/${mark}_*nodup.bam)
  featureCounts -a ../annotation/hg19.2k.tiling.saf -o counts/tiling.2k.${mark}.counts $files -F SAF -T 8 -O 
  done
wait; echo "feature counts done"

## count the reads against the 2k ATAC-seq array.
cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq/
if [ ! -d counts ]; then mkdir counts; fi
for mark in H3K27ac H3K27me3 H3K4me3 H3K4me1
  do
  files=$(ls bams/${mark}_*nodup.bam)
  featureCounts -a ../atac/peaks/atac_merged_peaks.summit.2k.saf -o counts/atac_peaks.2k.${mark}.counts $files -F SAF -T 8 -O
  done
wait; echo "feature counts done"


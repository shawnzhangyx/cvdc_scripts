# merge bam files
outdir=../../data/trackhub/hg19
## ATAC-seq
atacdir=../../data/atac/bams/
for day in 00 02 05 07 15 80
  do
#  (
#  samtools merge $atacdir/D${day}_sorted_nodup.30.bam $atacdir/D${day}_1_sorted_nodup.30.bam $atacdir/D${day}_2_sorted_nodup.30.bam -f 
#  samtools index $atacdir/D${day}_sorted_nodup.30.bam ) &
  (
  samtools merge $atacdir/D${day}_sorted_nodup-chrM.30.bam $atacdir/D${day}_1_sorted_nodup-chrM.30.bam $atacdir/D${day}_2_sorted_nodup-chrM.30.bam -f
  samtools index $atacdir/D${day}_sorted_nodup-chrM.30.bam ) &
  done

chipdir=../../data/chipseq/bams
for day in 00 02 05 07 15 80
  do
  for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3 Input #H3K9me3
    do
      (
      files=$(ls $chipdir/${mark}_D${day}_*.30.nodup.bam)
      echo $files
       samtools merge $chipdir/${mark}_D${day}.merged.bam $files -f
       samtools index $chipdir/${mark}_D${day}.merged.bam
      ) &
    done
  done

rnadir=../../data/rnaseq/bams/
#link bam files
for day in 0 2 5 7 15 80
  do
  num=$(printf "%02d" "$day")
  rep1=$(ls /mnt/silencer2/home/spreissl/CVDC/RNAseq/*_RNA_D${day}_1_nodup.bam)
  rep2=$(ls /mnt/silencer2/home/spreissl/CVDC/RNAseq/*_RNA_D${day}_2_nodup.bam)
  ln -s $rep1 $rnadir/rnaseq_D${num}_Rep1.bam
  ln -s $rep2 $rnadir/rnaseq_D${num}_Rep2.bam
  done
# merge and index bam files
for day in 00 02 05 07 15 80
  do
  (
  samtools merge $rnadir/rnaseq_D${day}.merged.bam $rnadir/rnaseq_D${day}_Rep1.bam $rnadir/rnaseq_D${day}_Rep2.bam -f 
  samtools index $rnadir/rnaseq_D${day}.merged.bam 
  ) &
  done


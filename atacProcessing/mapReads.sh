pushd ../../data/atac/
for name in D0_1 D0_2 D0b_1 D2_1 D2_2 D5_1 D5_2 D7_1 D7_2 D15_1 D15_2 D15b_1 D15b_2 D80_1 D80_2 D80b_1
  do
  file1=$(ls fastq/${name}_*_R1.fastq.bz2)
  file2=$(ls fastq/${name}_*_R2.fastq.bz2)
  echo $file1 $file2
  #bwa mem /mnt/silencer2/share/bwa_indices/hg19.fa <(bzcat $file1) <(bzcat $file2) -t 12 |samtools view -Sb - > bam/$name.raw.bam
  #samtools sort -@ 8 -m 4G bam/$name.raw.bam -T tmp -o bam/$name.sorted.bam
#  java -jar -Xmx80G ~/Pipelines/chipseq/dependencies/picard.jar MarkDuplicates INPUT=bam/$name.sorted.bam OUTPUT=bam/$name.dedup.bam ASSUME_SORTED=true REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=LENIENT TMP_DIR=tmp METRICS_FILE=bam/log/$name.metrics.log &> bam/log/$name.markdup.log
  
  done

files=$(ls bam/*.bam)
featureCounts -a peaks/atac_peaks.saf -o bam/atac.read.counts $files -F SAF -T 8


popd



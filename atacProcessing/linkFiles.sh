for day in 0 2 5 7 15 
  do 
  num=$(printf "%02d" "$day")
  ln -s $HOME/../spreissl/CVDC/ATAC/D${day}_1_sorted_nodup.bam ../../data/atac/bams/D${num}_1_sorted_nodup.bam
  ln -s $HOME/../spreissl/CVDC/ATAC/D${day}_2_sorted_nodup.bam ../../data/atac/bams/D${num}_2_sorted_nodup.bam
#  ln -s $HOME/../spreissl/CVDC/ATAC/D${day}_1_sorted_nodup.bai ../../data/atac/bams/D${num}_1_sorted_nodup.bam.bai
#  ln -s $HOME/../spreissl/CVDC/ATAC/D${day}_2_sorted_nodup.bai ../../data/atac/bams/D${num}_2_sorted_nodup.bam.bai
  ln -s $HOME/../spreissl/CVDC/ATAC/D${day}/IDR/pooled.truerep.narrowPeak ../../data/atac/peaks/D${num}.ATAC.truepeak.narrowPeak
  done

## day80 is different. 
day=80
num=$(printf "%02d" "$day")
ln -s $HOME/../spreissl/CVDC/ATAC/D${day}b_1_sorted_nodup.bam ../../data/atac/bams/D${num}_1_sorted_nodup.bam
ln -s $HOME/../spreissl/CVDC/ATAC/D${day}_2_sorted_nodup.bam ../../data/atac/bams/D${num}_2_sorted_nodup.bam
ln -s $HOME/../spreissl/CVDC/ATAC/D${day}b/IDR/pooled.truerep.narrowPeak ../../data/atac/peaks/D${num}.ATAC.truepeak.narrowPeak


for day in 0 2 5 7 15 80
  do
  num=$(printf "%02d" "$day")
  samtools index ../../data/atac/bams/D${num}_1_sorted_nodup.bam &
  samtools index ../../data/atac/bams/D${num}_2_sorted_nodup.bam &
  done
wait; echo done

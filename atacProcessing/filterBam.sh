cd /mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac/bams/
for day in 00 02 05 07 15 80
  do 
#  samtools view -b -q 30 D${day}_1_sorted_nodup.bam -o D${day}_1_sorted_nodup.30.bam -U D${day}_1_sorted_nodup.lt30.bam &
  samtools view -hS -q 30 D${day}_1_sorted_nodup.bam |grep -v chrM|samtools view -b -o D${day}_1_sorted_nodup-chrM.30.bam &
  samtools view -hS -q 30 D${day}_2_sorted_nodup.bam |grep -v chrM|samtools view -b -o D${day}_2_sorted_nodup-chrM.30.bam &
#  samtools view -b -q 30 D${day}_2_sorted_nodup.bam -o D${day}_2_sorted_nodup.30.bam -U D${day}_2_sorted_nodup.lt30.bam &
  done 


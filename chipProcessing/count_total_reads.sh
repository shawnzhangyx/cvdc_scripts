base=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq
stats=$base/stats
mkdir -p $stats
cd $base/bams/
#mark=H3K27me3
for mark in H3K27ac H3K27me3 H3K4me1 H3K4me3; do
  files=$(ls ${mark}*.nodup.bam)
  echo -e "sample\tTotal" > $stats/${mark}.mapped.total.txt 
  for file in $files; do
    echo -e "$file\t$(samtools view -c -F 4 $file)" >> $stats/${mark}.mapped.total.txt & 
    done
  wait
done


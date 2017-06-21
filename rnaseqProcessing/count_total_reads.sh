base=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/rnaseq
stats=$base/stats
mkdir -p $stats
cd $base/bams/
  files=$(ls rnaseq_D??_Rep?.bam)
  echo -e "sample\tTotal" > $stats/rnaseq.mapped.total.txt 
for file in $files; do
  echo -e "$file\t$(samtools view -c -F 4 $file)" >> $stats/rnaseq.mapped.total.txt & 
  done


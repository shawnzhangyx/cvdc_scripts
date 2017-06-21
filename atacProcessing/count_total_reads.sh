base=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/atac
stats=$base/stats
mkdir -p $stats
cd $base/bams/
  files=$(ls D??_?_sorted_nodup-chrM.30.bam)
  echo -e "sample\tTotal" > $stats/atac.mapped.total.txt 
for file in $files; do
  echo -e "$file\t$(samtools view -c -F 4 $file)" >> $stats/atac.mapped.total.txt & 
  done


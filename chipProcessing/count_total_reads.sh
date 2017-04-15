base=/mnt/silencer2/home/yanxiazh/projects/cardiac_dev/data/chipseq
stats=$base/stats
if [ ! -d $stats ]; then mkdir $stats; fi 
if [ ! -d $stats/mapped_reads/ ]; then mkdir $stats/mapped_reads; fi
mark=H3K27me3
cd $base/bams/
files=$(ls ${mark}*.bam)

for file in $files 
  do
  echo $file >> $stats/mapped_reads/${mark}.names 
  samtools view -c -F 4 $file >> $stats/mapped_reads/${mark}.counts
  done


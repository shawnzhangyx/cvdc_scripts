
for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  (
  for chr in {1..22..1} X; do
  chr_size=$(awk -v chr=$chr '{if ($1=="chr"chr ){ print $2}}' /mnt/tscc/share/bowtie_indexes/hg19.fa.fai)
    echo $chr $chr_size
    ./col2mat.awk -v chr=$chr -v bin_size=10000 -v chr_size=$chr_size ../../data/hic/matrix/$sample/${chr}_10000.txt |gzip > ../../data/hic/table2x2/$sample/chr${chr}.tab.gz
  done
  ) &
  done

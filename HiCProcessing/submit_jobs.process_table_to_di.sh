sample=D00_HiC_Rep1
chr=22
bin_size=10000
bin_num=200

for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  for chr in {22..1..1} X; do
    if [ ! -e ../../data/hic/DI/$sample/chr${chr}.${bin_size}.${bin_num}.DI.bedGraph ]; then
        echo $sample $chr;
        qsub process_table_to_di.qs -v bin_size=$bin_size,bin_num=$bin_num,sample=$sample,chr=$chr;
    fi
  done
done

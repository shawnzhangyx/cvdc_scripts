sample=D02_HiC_Rep2
chr=1
bin_size=10000
bin_num=50

for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  ( 
  for chr in {22..1..1} X; do
    echo $chr 
  Rscript mat2di.r ../../data/hic/table2x2/$sample/chr${chr}.tab.gz $chr $bin_size $bin_num ../../data/hic/DI/$sample/chr${chr}.${bin_size}.${bin_num}.DI.bedGraph
  done
  ) &
  done
  wait

for sample in $(cat ../../data/hic/meta/names.txt); do
  echo $sample
  cat ../../data/hic/DI/$sample/*.bedGraph |grep -v NA > ../../data/hic/DI/${sample}.10000.50.DI.bedGraph
  done


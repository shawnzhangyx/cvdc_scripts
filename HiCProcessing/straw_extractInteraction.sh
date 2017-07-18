set -o
set -e

pushd ../../data/hic/
chr=chr1
for name in $(cat meta/names.txt);do 
  sample=juicer/${name}.hic
  echo $name 
  ../../scripts/utility/straw NONE $sample $chr $chr BP 50000 > matrix_raw/$name/${chr}_50k.txt
  done
popd

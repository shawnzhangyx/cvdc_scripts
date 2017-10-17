set -o
set -e

pushd ../../data/hic/
#for name in $(cat meta/names.txt);do 
for name in $(cat ../../data/hic/meta/names.txt) ;do  
  (
  sample=juicer/${name}.hic
  echo $name 
  for chr1 in {1..22}; do
#    for chr2 in $(seq $((${chr1} + 1)) 22) X;do
#    if [ ! -e matrix_raw/$name/${chr1}_${chr2}.50k.mat ]; then 
    chr2=$chr1
    echo $chr1,$chr2
    ../../scripts/utility/straw NONE $sample chr$chr1 chr$chr2 BP 50000 > matrix_raw/$name/${chr1}_${chr2}.50k.mat
#    fi
#    done
  done
  ) &
done

popd




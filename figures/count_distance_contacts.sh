pushd ../../analysis/distance_vs_prob/
for sample in $(cat ../../data/hic/meta/names.txt);do 
(
  for chr in {1..22}; do
  files="$files ../../data/hic/matrix_raw/${sample}/${chr}_${chr}.50k.mat"
  done
  echo $files 
  awk '{dist=$2-$1;mat[dist]+=$3} END { for (dist in mat){print dist,mat[dist]} }' $files |sort -k1,1n >   $sample.dist.contacts 
  )   &
  done


for sample in $(cat ../../data/hic/meta/names.txt);do
(
  for chr in {1..22}; do
  files="$files ../../data/hic/matrix_raw/${sample}/${chr}_10000.txt"
  done
  echo $files
  awk '{dist=$2-$1;mat[dist]+=$3} END { for (dist in mat){print dist,mat[dist]} }' $files |sort -k1,1n >   $sample.dist.contacts.10k
  )   &
  done


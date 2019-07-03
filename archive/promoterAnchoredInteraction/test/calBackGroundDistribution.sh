pushd ../../analysis/promoterAnchoredInteractions
#name=D00_HiC_Rep1
for name in $(cat ../../data/hic/meta/names.txt); do
(
echo $name 
chr=1
mkdir -p $name 
for chr in {1..22} X; do 
echo $chr 
awk -v OFS='\t' '{dist=$2-$1;mat[dist] += $3;count[dist]++ }END {for (i in mat){print i,mat[i],count[i]} }' ../../data/hic/matrix/$name/${chr}_10000.txt |sort -k1,1n > $name/${chr}.dist.total
done 

cat $name/{?,??}.dist.total | awk -v OFS='\t' '{mat[$1] += $2;count[$1]+= $3 }END {for (i in mat){print i,mat[i],count[i]} }' |sort -k1,1n > $name/all.dist.total
) &
done 
popd 

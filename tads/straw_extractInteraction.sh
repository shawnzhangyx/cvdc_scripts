mkdir -p ../../analysis/tads/contacts_by_samples/
#sample=../../data/hic/juicer/D00_HiC_Rep1.hic 
for name in $(cat ../../data/hic/meta/names.txt);do 
sample=../../data/hic/juicer/${name}.hic

## 10kb 
echo $name 
echo -e "chr\tx1\tx2\ty1\ty2\tcontacts" > \
  ../../analysis/tads/contacts_by_samples/$name.contacts.10k.txt
tail -n +2  ../../analysis/tads/combined_tads.uniq.txt |
while read chr1 x1 x2 chr2 y1 y2 field4; do
#  contact=$(../utility/straw KR $sample chr$chr1:$x1:$x2 chr$chr2:$y1:$y2 BP 10000 |cut -f 3)
#  if [ -z "$contact" ]; then contact=0;fi 
  echo -e "$(../utility/straw NONE $sample chr$chr1:$x1:$x2 chr$chr2:$y1:$y2 BP 10000 | awk -v chr=$chr1 -v x1=$x1 -v x2=$x2 -v OFS="\t" '{print chr,x1,x2,$0}')" \
  >> ../../analysis/tads/contacts_by_samples/$name.contacts.10k.txt
    done &

done 
wait
for name in $(cat ../../data/hic/meta/names.txt);do
Rscript ../../scripts/tads/sum_tad_counts_each_sample.r contacts_by_samples/$name.contacts.10k.txt contacts_by_samples/$name.tad.sum.txt &
done
wait
Rscript merge_tad_counts_across_stages.r
#pushd ../../analysis/tads/
#echo -e "chr\tx1\ty1\tD00_1\tD00_2\tD02_1\tD02_2\tD05_1\tD05_2\tD07_1\tD07_2\tD15_1\tD15_2\tD80_1\tD80_2" |tee combined_tads.uniq.counts.txt 
#paste contacts_by_samples/*.contacts.10k.txt | \
#  cut -f 1,2,3,$(seq -s, 4 4 $((4*12)) ) | tail -n +2 >> combined_tads.uniq.counts.txt
#popd
